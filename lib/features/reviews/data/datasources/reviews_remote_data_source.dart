import '../../../../core/network/api_client.dart';
import '../../domain/entities/review.dart';

/// Remote implementation of reviews data source backed by the Dokal backend REST API.
class ReviewsRemoteDataSourceImpl {
  ReviewsRemoteDataSourceImpl({required this.api});

  final ApiClient api;

  /// Creates a new review for an appointment.
  ///
  /// Sends a POST request to `/api/v1/reviews` with the review data.
  ///
  /// Returns the created [Review] entity.
  /// Throws [ServerException] if the request fails.
  Future<Review> createReviewAsync({
    required String appointmentId,
    required String practitionerId,
    required int rating,
    String? comment,
  }) async {
    final json = await api.post(
      '/api/v1/reviews',
      data: {
        'appointment_id': appointmentId,
        'practitioner_id': practitionerId,
        'rating': rating,
        if (comment != null) 'comment': comment,
      },
    ) as Map<String, dynamic>;
    return _mapReview(json);
  }

  /// Maps a backend review JSON response to a [Review] entity.
  static Review _mapReview(Map<String, dynamic> json) {
    final profiles = json['profiles'] as Map<String, dynamic>?;
    final firstName = profiles?['first_name'] as String? ?? '';
    final lastName = profiles?['last_name'] as String? ?? '';
    final patientName = '$firstName $lastName'.trim();

    return Review(
      id: json['id'] as String,
      appointmentId: json['appointment_id'] as String,
      practitionerId: json['practitioner_id'] as String,
      patientId: json['patient_id'] as String,
      rating: json['rating'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
      comment: json['comment'] as String?,
      practitionerReply: json['practitioner_reply'] as String?,
      patientName: patientName.isEmpty ? null : patientName,
    );
  }
}
