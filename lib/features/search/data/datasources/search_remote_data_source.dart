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
    final data = await api.get(
      '/api/v1/practitioners/search',
      queryParameters: {
        if (query.isNotEmpty) 'q': query,
        'limit': 50,
      },
    ) as List<dynamic>;

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

      return PractitionerSearchResult(
        id: json['id'] as String,
        name: '$firstName $lastName'.trim(),
        specialty: spec?['name_fr'] as String? ??
            spec?['name'] as String? ??
            '',
        address:
            '${json['address_line'] ?? ''}, ${json['city'] ?? ''}'.trim(),
        sector: json['sector'] as String? ?? '',
        nextAvailabilityLabel: '',
        avatarUrl: profiles?['avatar_url'] as String?,
        distanceKm: null,
        availabilityOrder: null,
      );
    }).toList();
  }
}
