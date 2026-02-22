import '../../../../core/network/api_client.dart';
import '../../domain/entities/appointment.dart';
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
    return data.map(_mapAppointment).toList();
  }

  Future<List<Appointment>> pastAsync() async {
    final data = await api.get('/api/v1/appointments/past') as List<dynamic>;
    return data.map((j) => _mapAppointment(j, isPast: true)).toList();
  }

  Future<Appointment?> getByIdAsync(String id) async {
    final json =
        await api.get('/api/v1/appointments/$id') as Map<String, dynamic>;
    return _mapAppointment(json);
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
    return json != null ? _mapAppointment(json) : null;
  }

  static String _ensureTimeFormat(String time) {
    if (time.length == 5 && time[2] == ':') return '$time:00';
    return time;
  }

  // ---- mapping helper ----

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
      address: json['patient_address_line'] as String?,
      avatarUrl: practitionerProfiles?['avatar_url'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
      practitionerNotes: json['practitioner_notes'] as String?,
      confirmedAt: json['confirmed_at'] as String?,
      cancelledAt: json['cancelled_at'] as String?,
      completedAt: json['completed_at'] as String?,
    );
  }
}
