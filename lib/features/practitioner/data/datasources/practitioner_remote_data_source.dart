import '../../../../core/network/api_client.dart';
import '../../../reviews/domain/entities/review.dart';
import '../../domain/entities/practitioner_profile.dart';
import 'practitioner_demo_data_source.dart';

/// Remote implementation of [PractitionerDemoDataSource] backed by the Dokal
/// backend REST API.
class PractitionerRemoteDataSourceImpl implements PractitionerDemoDataSource {
  PractitionerRemoteDataSourceImpl({required this.api});

  final ApiClient api;

  @override
  PractitionerProfile getById(String id) {
    throw UnimplementedError('Use getByIdAsync instead');
  }

  Future<PractitionerProfile> getByIdAsync(String id) async {
    final json =
        await api.get('/api/v1/practitioners/$id') as Map<String, dynamic>;

    final profiles = json['profiles'] as Map<String, dynamic>?;

    // specialties: single object (FK one-to-one) or null
    final specRaw = json['specialties'];
    final Map<String, dynamic>? specialties = specRaw is Map<String, dynamic>
        ? specRaw
        : specRaw is List && specRaw.isNotEmpty
            ? specRaw.first as Map<String, dynamic>
            : null;

    final firstName = profiles?['first_name'] as String? ?? '';
    final lastName = profiles?['last_name'] as String? ?? '';

    // Slots -> formatted availability labels
    final rawSlots = json['slots'] as List<dynamic>? ?? [];
    final availabilities = rawSlots.take(6).map((s) {
      final slot = s as Map<String, dynamic>;
      final date = slot['slot_date'] as String? ?? '';
      final time =
          (slot['slot_start'] as String? ?? '').substring(0, 5);
      return '$date $time';
    }).toList();

    // Languages
    final rawLangs = json['languages'];
    List<String>? languages;
    if (rawLangs is List) {
      languages = rawLangs.cast<String>();
    }

    // Compute average rating from embedded reviews
    final rawReviews = json['reviews'] as List<dynamic>? ?? [];
    double? rating;
    if (rawReviews.isNotEmpty) {
      final total = rawReviews.fold<double>(0, (sum, r) {
        final rev = r as Map<String, dynamic>;
        return sum + (rev['rating'] as num? ?? 0).toDouble();
      });
      rating = total / rawReviews.length;
    }

    return PractitionerProfile(
      id: json['id'] as String,
      name: '$firstName $lastName'.trim(),
      specialty: specialties?['name_fr'] as String? ??
          specialties?['name'] as String? ??
          '',
      address:
          '${json['address_line'] ?? ''}, ${json['zip_code'] ?? ''} ${json['city'] ?? ''}'
              .trim(),
      about: json['about'] as String? ?? '',
      nextAvailabilities: availabilities,
      avatarUrl: profiles?['avatar_url'] as String?,
      sector: json['sector'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      languages: languages,
      education: json['education'] as String?,
      yearsOfExperience: json['years_of_experience'] as int?,
      consultationDurationMinutes:
          json['consultation_duration_minutes'] as int?,
      isAcceptingNewPatients:
          json['is_accepting_new_patients'] as bool? ?? true,
      rating: rating,
      reviewCount: rawReviews.length,
    );
  }

  /// Fetch available slots for a practitioner within a date range.
  Future<List<Map<String, String>>> getSlotsAsync(
    String id, {
    required String from,
    required String to,
  }) async {
    final data = await api.get(
      '/api/v1/practitioners/$id/slots',
      queryParameters: {'from': from, 'to': to},
    ) as List<dynamic>;

    return data.map((raw) {
      final slot = raw as Map<String, dynamic>;
      return {
        'slot_date': slot['slot_date'] as String? ?? '',
        'slot_start': slot['slot_start'] as String? ?? '',
        'slot_end': slot['slot_end'] as String? ?? '',
      };
    }).toList();
  }

  /// Fetch paginated reviews for a practitioner.
  Future<List<Review>> getReviewsAsync(
    String id, {
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await api.get(
      '/api/v1/practitioners/$id/reviews',
      queryParameters: {'limit': limit, 'offset': offset},
    ) as Map<String, dynamic>;
    final data = response['reviews'] as List<dynamic>? ?? [];

    return data.map((raw) {
      final json = raw as Map<String, dynamic>;
      final patient = json['profiles'] as Map<String, dynamic>?;
      final firstName = patient?['first_name'] as String? ?? '';
      final lastName = patient?['last_name'] as String? ?? '';
      return Review(
        id: json['id'] as String,
        appointmentId: json['appointment_id'] as String? ?? '',
        practitionerId: json['practitioner_id'] as String? ?? id,
        patientId: json['patient_id'] as String? ?? '',
        rating: json['rating'] as int? ?? 0,
        comment: json['comment'] as String?,
        practitionerReply: json['practitioner_reply'] as String?,
        createdAt: json['created_at'] as String? ?? '',
        patientName: '$firstName $lastName'.trim(),
      );
    }).toList();
  }
}
