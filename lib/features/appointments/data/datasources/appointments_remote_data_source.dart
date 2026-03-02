import '../../../../core/network/api_client.dart';
import '../../../../l10n/app_locale_controller.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/entities/questionnaire_field.dart';
import 'appointments_demo_data_source.dart';

/// Remote implementation of [AppointmentsDemoDataSource] backed by the Dokal
/// backend REST API.
class AppointmentsRemoteDataSourceImpl implements AppointmentsDemoDataSource {
  AppointmentsRemoteDataSourceImpl({required this.api});

  final ApiClient api;

  // ---- sync stubs (repo calls async variants) ----

  @override
  List<Appointment> upcoming() => throw UnimplementedError('Use upcomingAsync');

  @override
  List<Appointment> past() => throw UnimplementedError('Use pastAsync');

  @override
  Appointment? getById(String id) =>
      throw UnimplementedError('Use getByIdAsync');

  @override
  void cancel(String id) => throw UnimplementedError('Use cancelAsync');

  // ---- async real implementations ----

  Future<List<Appointment>> upcomingAsync() async {
    final data =
        await api.get('/api/v1/appointments/upcoming') as List<dynamic>;
    final appointments = data.map(_mapAppointment).toList();
    return _enrichWithPractitionerAddresses(appointments);
  }

  Future<List<Appointment>> pastAsync() async {
    final data = await api.get('/api/v1/appointments/past') as List<dynamic>;
    final appointments =
        data.map((j) => _mapAppointment(j, isPast: true)).toList();
    return _enrichWithPractitionerAddresses(appointments);
  }

  Future<Appointment?> getByIdAsync(String id) async {
    final json =
        await api.get('/api/v1/appointments/$id') as Map<String, dynamic>;
    final appointment = _mapAppointment(json);
    if (appointment.address == null &&
        appointment.practitionerId.isNotEmpty) {
      final addr = await _fetchPractitionerAddress(appointment.practitionerId);
      if (addr != null) return appointment.copyWith(address: addr);
    }
    return appointment;
  }

  Future<void> cancelAsync(String id, {String? reason}) async {
    await api.patch(
      '/api/v1/appointments/$id/cancel',
      data: {'cancellation_reason': reason},
    );
  }

  /// Reschedule an appointment to a new date/time.
  /// Requires backend: PATCH /api/v1/appointments/{id}/reschedule
  Future<Appointment?> rescheduleAsync(
    String id, {
    required String appointmentDate,
    required String startTime,
    required String endTime,
  }) async {
    final start = _ensureTimeFormat(startTime);
    final end = _ensureTimeFormat(endTime);
    final json = await api.patch(
      '/api/v1/appointments/$id/reschedule',
      data: {
        'appointment_date': appointmentDate,
        'start_time': start,
        'end_time': end,
      },
    ) as Map<String, dynamic>?;
    if (json == null) return null;
    final appointment = _mapAppointment(json);
    if (appointment.address == null &&
        appointment.practitionerId.isNotEmpty) {
      final addr = await _fetchPractitionerAddress(appointment.practitionerId);
      if (addr != null) return appointment.copyWith(address: addr);
    }
    return appointment;
  }

  /// Submit the patient's questionnaire answers before the appointment.
  ///
  /// Backend: POST /api/v1/appointments/{id}/questionnaire
  /// Body: `{ "consent": true, "answers": { "<field_id>": "<value>", ... } }`
  Future<void> submitQuestionnaireAsync(
    String appointmentId, {
    required Map<String, String> answers,
    required bool consent,
  }) async {
    await api.post(
      '/api/v1/appointments/$appointmentId/questionnaire',
      data: {
        'consent': consent,
        'answers': answers,
      },
    );
  }

  /// Mark the pre-visit instructions as read by the patient.
  ///
  /// Backend: POST /api/v1/appointments/{id}/instructions/read
  Future<void> markInstructionsReadAsync(String appointmentId) async {
    await api.post(
      '/api/v1/appointments/$appointmentId/instructions/read',
      data: {},
    );
  }

  /// Get earlier slot alert status for an appointment.
  Future<bool> getEarlierSlotAlertAsync(String appointmentId) async {
    final json = await api.get('/api/v1/appointments/$appointmentId/earlier-alert')
        as Map<String, dynamic>;
    return json['enabled'] as bool? ?? false;
  }

  /// Enable or disable earlier slot alert for an appointment.
  Future<void> setEarlierSlotAlertAsync(String appointmentId, {required bool enabled}) async {
    await api.post(
      '/api/v1/appointments/$appointmentId/earlier-alert',
      data: {'enabled': enabled},
    );
  }

  /// Fetches practitioner addresses for appointments that are missing one.
  Future<List<Appointment>> _enrichWithPractitionerAddresses(
    List<Appointment> appointments,
  ) async {
    final needsAddress =
        appointments.where((a) => a.address == null && a.practitionerId.isNotEmpty);
    if (needsAddress.isEmpty) return appointments;

    final uniqueIds = needsAddress.map((a) => a.practitionerId).toSet();
    final addressMap = <String, String>{};
    await Future.wait(
      uniqueIds.map((id) async {
        final addr = await _fetchPractitionerAddress(id);
        if (addr != null) addressMap[id] = addr;
      }),
    );
    if (addressMap.isEmpty) return appointments;

    return appointments.map((a) {
      if (a.address == null && addressMap.containsKey(a.practitionerId)) {
        return a.copyWith(address: addressMap[a.practitionerId]);
      }
      return a;
    }).toList();
  }

  Future<String?> _fetchPractitionerAddress(String practitionerId) async {
    try {
      final json = await api.get('/api/v1/practitioners/$practitionerId')
          as Map<String, dynamic>;
      final addrLine = json['address_line'] as String?;
      if (addrLine == null || addrLine.isEmpty) return null;
      final zip = json['zip_code'] as String? ?? '';
      final city = json['city'] as String? ?? '';
      final suffix = '$zip $city'.trim();
      return suffix.isEmpty ? addrLine : '$addrLine, $suffix';
    } catch (_) {
      return null;
    }
  }

  /// Tries practitioner address fields first, falls back to patient_address_line.
  static String? _extractAddress(
    Map<String, dynamic> json,
    Map<String, dynamic>? practitioners,
  ) {
    final addrLine = practitioners?['address_line'] as String?;
    if (addrLine != null && addrLine.isNotEmpty) {
      final zip = practitioners?['zip_code'] as String? ?? '';
      final city = practitioners?['city'] as String? ?? '';
      final suffix = '$zip $city'.trim();
      return suffix.isEmpty ? addrLine : '$addrLine, $suffix';
    }
    return json['patient_address_line'] as String?;
  }

  static String _ensureTimeFormat(String time) {
    if (time.length == 5 && time[2] == ':') return '$time:00';
    return time;
  }

  // ---- mapping helpers ----

  static Appointment _mapAppointment(dynamic raw, {bool isPast = false}) {
    final json = raw as Map<String, dynamic>;

    // Nested practitioner
    final practitioners = json['practitioners'] as Map<String, dynamic>?;
    final practitionerProfiles =
        practitioners?['profiles'] as Map<String, dynamic>?;
    final specialties = practitioners?['specialties'] as Map<String, dynamic>?;
    final reasons = json['appointment_reasons'] as Map<String, dynamic>?;
    final relatives = json['relatives'] as Map<String, dynamic>?;

    final practFirstName = practitionerProfiles?['first_name'] as String? ?? '';
    final practLastName = practitionerProfiles?['last_name'] as String? ?? '';

    final status = json['status'] as String? ?? 'pending';
    final computedIsPast =
        isPast ||
        status == 'completed' ||
        status == 'cancelled_by_patient' ||
        status == 'cancelled_by_practitioner' ||
        status == 'no_show';

    String? patientName;
    if (relatives != null) {
      final fn = relatives['first_name'] as String? ?? '';
      final ln = relatives['last_name'] as String? ?? '';
      patientName = '$fn $ln'.trim();
      if (patientName.isEmpty) patientName = null;
    }

    // Dynamic pre-visit instructions set by the practitioner
    final rawInstructions = json['pre_visit_instructions'] as List<dynamic>?;
    final instructions = rawInstructions
            ?.whereType<String>()
            .where((s) => s.trim().isNotEmpty)
            .toList() ??
        [];

    // Translations of instructions keyed by locale
    final rawInstrTrans =
        json['pre_visit_instructions_translations'] as Map<String, dynamic>?;
    Map<String, List<String>>? instructionsTranslations;
    if (rawInstrTrans != null && rawInstrTrans.isNotEmpty) {
      instructionsTranslations = {};
      for (final entry in rawInstrTrans.entries) {
        final list = (entry.value as List<dynamic>?)
            ?.whereType<String>()
            .toList();
        if (list != null && list.isNotEmpty) {
          instructionsTranslations[entry.key] = list;
        }
      }
      if (instructionsTranslations.isEmpty) instructionsTranslations = null;
    }

    // Dynamic questionnaire fields configured by the practitioner
    final rawFields = json['questionnaire_fields'] as List<dynamic>?;
    final questionnaireFields = rawFields
            ?.whereType<Map<String, dynamic>>()
            .map(_mapQuestionnaireField)
            .toList() ??
        [];

    return Appointment(
      id: json['id'] as String,
      practitionerId: practitioners?['id'] as String? ?? '',
      dateLabel: json['appointment_date'] as String? ?? '',
      timeLabel: (json['start_time'] as String? ?? '').substring(0, 5), // HH:mm
      practitionerName: '$practFirstName $practLastName'.trim(),
      specialty:
          specialties?['name_fr'] as String? ??
          specialties?['name'] as String? ??
          '',
      reason:
          reasons?['label_fr'] as String? ?? reasons?['label'] as String? ?? '',
      status: status,
      isPast: computedIsPast,
      patientName: patientName,
      address: _extractAddress(json, practitioners),
      avatarUrl: practitionerProfiles?['avatar_url'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
      practitionerNotes: json['practitioner_notes'] as String?,
      confirmedAt: json['confirmed_at'] as String?,
      cancelledAt: json['cancelled_at'] as String?,
      completedAt: json['completed_at'] as String?,
      instructions: instructions,
      instructionsTranslations: instructionsTranslations,
      questionnaireFields: questionnaireFields,
      questionnaireSubmittedAt:
          json['questionnaire_submitted_at'] as String?,
      instructionsReadAt:
          json['instructions_read_at'] as String?,
    );
  }

  static QuestionnaireField _mapQuestionnaireField(
    Map<String, dynamic> json,
  ) {
    final label = json['label'] as String? ?? '';

    // Parse translations map from backend (AI-generated)
    Map<String, String>? translations;
    final rawTrans = json['translations'] as Map<String, dynamic>?;
    if (rawTrans != null && rawTrans.isNotEmpty) {
      translations = {};
      for (final entry in rawTrans.entries) {
        if (entry.value is String) {
          translations[entry.key] = entry.value as String;
        }
      }
      if (translations.isEmpty) translations = null;
    }

    return QuestionnaireField(
      id: json['id'] as String? ?? '',
      label: label,
      isRequired: json['required'] as bool? ?? false,
      maxLines: json['max_lines'] as int? ?? 2,
      translations: translations,
    );
  }
}
