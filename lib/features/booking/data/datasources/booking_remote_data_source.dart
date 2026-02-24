import '../../../../core/network/api_client.dart';

/// Remote datasource for booking backed by the Dokal backend REST API.
class BookingRemoteDataSourceImpl {
  BookingRemoteDataSourceImpl({required this.api});

  final ApiClient api;

  /// Production booking call with structured slot data.
  /// Address fields can be empty; API accepts nullable values.
  Future<String> confirmStructured({
    required String practitionerId,
    String? relativeId,
    String? reasonId,
    required String appointmentDate,
    required String startTime,
    required String endTime,
    String? addressLine,
    String? zipCode,
    String? city,
    bool visitedBefore = false,
  }) async {
    final json =
        await api.post(
              '/api/v1/appointments',
              data: {
                'practitioner_id': practitionerId,
                'relative_id': relativeId,
                'reason_id': reasonId,
        'appointment_date': appointmentDate,
        'start_time': _ensureTimeFormat(startTime),
        'end_time': _ensureTimeFormat(endTime),
        if (addressLine != null && addressLine.isNotEmpty)
          'patient_address_line': addressLine,
        if (zipCode != null && zipCode.isNotEmpty)
          'patient_zip_code': zipCode,
        if (city != null && city.isNotEmpty) 'patient_city': city,
        'visited_before': visitedBefore,
              },
            )
            as Map<String, dynamic>;
    return json['id'] as String;
  }

  /// Ensures time is in HH:mm:ss format for API compatibility.
  static String _ensureTimeFormat(String time) {
    if (time.length == 5 && time[2] == ':') {
      return '$time:00';
    }
    return time;
  }
}
