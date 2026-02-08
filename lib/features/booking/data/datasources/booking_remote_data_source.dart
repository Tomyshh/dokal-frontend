import '../../../../core/network/api_client.dart';
import 'booking_demo_data_source.dart';

/// Remote implementation of [BookingDemoDataSource] backed by the Dokal
/// backend REST API.
class BookingRemoteDataSourceImpl implements BookingDemoDataSource {
  BookingRemoteDataSourceImpl({required this.api});

  final ApiClient api;

  @override
  Future<String> confirm({
    required String practitionerId,
    required String reason,
    required String patientLabel,
    required String slotLabel,
    required String addressLine,
    required String zipCode,
    required String city,
    required bool visitedBefore,
  }) async {
    // Parse slotLabel ("Monday, February 3, 2026 • 11:00") into date + time
    // The slot is selected from real backend slots so we receive structured
    // data via an extended confirm method.  For backwards compat we fallback
    // to passing raw strings if the structured data is not available.
    // The repository will call confirmStructured() directly in production.
    throw UnimplementedError('Use confirmStructured instead');
  }

  /// Production booking call with structured slot data.
  Future<String> confirmStructured({
    required String practitionerId,
    String? relativeId,
    String? reasonId,
    required String appointmentDate,
    required String startTime,
    required String endTime,
    required String addressLine,
    required String zipCode,
    required String city,
    required bool visitedBefore,
  }) async {
    final json = await api.post('/api/v1/appointments', data: {
      'practitioner_id': practitionerId,
      'relative_id': relativeId,
      'reason_id': reasonId,
      'appointment_date': appointmentDate,
      'start_time': startTime,
      'end_time': endTime,
      'patient_address_line': addressLine,
      'patient_zip_code': zipCode,
      'patient_city': city,
      'visited_before': visitedBefore,
    }) as Map<String, dynamic>;
    return json['id'] as String;
  }
}
