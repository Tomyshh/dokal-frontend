import '../../../../core/network/api_client.dart';
import '../../domain/entities/practitioner_search_result.dart';

/// Remote datasource for practitioner search backed by the Dokal backend REST API.
class SearchRemoteDataSourceImpl {
  SearchRemoteDataSourceImpl({required this.api});

  final ApiClient api;

  Future<List<PractitionerSearchResult>> searchAsync(
    String query, {
    double? lat,
    double? lng,
  }) async {
    // lat et lng doivent toujours être envoyés ensemble (sinon API 400)
    final params = <String, dynamic>{
      if (query.isNotEmpty) 'q': query,
      'limit': 50,
      if (lat != null && lng != null) ...{'lat': lat, 'lng': lng},
    };
    final data =
        await api.get(
              '/api/v1/practitioners/search',
              queryParameters: params,
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

      // Ville (praticien, organisation, ou extraite de l'adresse)
      final org = json['organizations'];
      final orgMap = org is Map<String, dynamic>
          ? org
          : org is List && org.isNotEmpty
              ? org.first as Map<String, dynamic>?
              : null;
      final cityRaw = json['city'] ?? orgMap?['city'];
      var cityStr =
          (cityRaw is String? ? cityRaw : cityRaw?.toString())?.trim();
      if ((cityStr == null || cityStr.isEmpty) && json['address_line'] != null) {
        final addr = json['address_line'].toString().trim();
        final parts = addr.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
        if (parts.length > 1) {
          cityStr = parts.last;
        }
      }
      final city =
          (cityStr != null && cityStr.isNotEmpty) ? cityStr : null;

      // distance_km fourni par l'API lorsque lat/lng sont envoyés
      final distanceKm = (json['distance_km'] as num?)?.toDouble();
      final distanceLabel = distanceKm != null ? _formatDistanceKm(distanceKm) : null;

      return PractitionerSearchResult(
        id: json['id'] as String,
        name: '$firstName $lastName'.trim(),
        specialty:
            spec?['name_fr'] as String? ?? spec?['name'] as String? ?? '',
        address: '${json['address_line'] ?? ''}, ${json['city'] ?? ''}'.trim(),
        sector: json['sector'] as String? ?? '',
        city: city,
        nextAvailabilityLabel: nextAvailabilityLabel,
        avatarUrl: profiles?['avatar_url'] as String?,
        languages: languages,
        distanceKm: distanceKm,
        distanceLabel: distanceLabel,
        availabilityOrder: null,
        rating: rating,
        reviewCount: reviewCount,
        priceMinAgorot: priceMin,
        priceMaxAgorot: priceMax,
      );
    }).toList();
  }

  static String _formatDistanceKm(double km) {
    if (km < 1) {
      return '${km.toStringAsFixed(1)} km';
    }
    return km == km.roundToDouble()
        ? '${km.round()} km'
        : '${km.toStringAsFixed(1)} km';
  }
}
