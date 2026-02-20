import '../../../../core/network/api_client.dart';
import '../../domain/entities/practitioner_search_result.dart';
import 'search_demo_data_source.dart';

/// Remote implementation of [SearchDemoDataSource] backed by the Dokal
/// backend REST API.
class SearchRemoteDataSourceImpl implements SearchDemoDataSource {
  SearchRemoteDataSourceImpl({required this.api});

  final ApiClient api;

  @override
  List<PractitionerSearchResult> search(String query) {
    throw UnimplementedError('Use searchAsync instead');
  }

  Future<List<PractitionerSearchResult>> searchAsync(String query) async {
    final data =
        await api.get(
              '/api/v1/practitioners/search',
              queryParameters: {if (query.isNotEmpty) 'q': query, 'limit': 50},
            )
            as List<dynamic>;

    return data.map((raw) {
      final json = raw as Map<String, dynamic>;
      final profiles = json['profiles'] as Map<String, dynamic>?;

      // specialties can be a single object (FK one-to-one) or null
      final specRaw = json['specialties'];
      final Map<String, dynamic>? spec = specRaw is Map<String, dynamic>
          ? specRaw
          : specRaw is List && specRaw.isNotEmpty
          ? specRaw.first as Map<String, dynamic>
          : null;

      final firstName = profiles?['first_name'] as String? ?? '';
      final lastName = profiles?['last_name'] as String? ?? '';

      // Note moyenne : préférer average_rating de l'API, sinon calculer depuis reviews
      double? rating = (json['average_rating'] as num?)?.toDouble();
      int? reviewCount = json['review_count'] as int? ?? json['count'] as int?;
      if (rating == null) {
        final rawReviews = json['reviews'] as List<dynamic>? ?? [];
        if (rawReviews.isNotEmpty) {
          final total = rawReviews.fold<double>(0, (sum, r) {
            final rev = r as Map<String, dynamic>;
            return sum + (rev['rating'] as num? ?? 0).toDouble();
          });
          rating = total / rawReviews.length;
          reviewCount ??= rawReviews.length;
        }
      }

      // Fourchette de prix (agorot = ILS × 100)
      final priceMin = json['price_min_agorot'] as int?;
      final priceMax = json['price_max_agorot'] as int?;

      // Parse first slot for next availability
      final rawSlots = json['slots'] as List<dynamic>? ?? [];
      String nextAvailabilityLabel = '';
      if (rawSlots.isNotEmpty) {
        final slot = rawSlots.first as Map<String, dynamic>;
        final date = slot['slot_date'] as String? ?? '';
        final start = slot['slot_start'] as String? ?? '';
        if (date.isNotEmpty && start.isNotEmpty) {
          final time = start.length >= 5 ? start.substring(0, 5) : start;
          nextAvailabilityLabel = '$date $time';
        }
      }

      // Langues parlées (profiles.languages ou root)
      List<String>? languages;
      final rawLangs = profiles?['languages'] ?? json['languages'];
      if (rawLangs is List) {
        languages = rawLangs
            .whereType<String>()
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
        if (languages.isEmpty) languages = null;
      }

      return PractitionerSearchResult(
        id: json['id'] as String,
        name: '$firstName $lastName'.trim(),
        specialty:
            spec?['name_fr'] as String? ?? spec?['name'] as String? ?? '',
        address: '${json['address_line'] ?? ''}, ${json['city'] ?? ''}'.trim(),
        sector: json['sector'] as String? ?? '',
        nextAvailabilityLabel: nextAvailabilityLabel,
        avatarUrl: profiles?['avatar_url'] as String?,
        languages: languages,
        distanceKm: null,
        availabilityOrder: null,
        rating: rating,
        reviewCount: reviewCount,
        priceMinAgorot: priceMin,
        priceMaxAgorot: priceMax,
      );
    }).toList();
  }
}
