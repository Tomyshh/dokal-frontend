import '../../domain/entities/practitioner_search_result.dart';

abstract class SearchDemoDataSource {
  List<PractitionerSearchResult> search(String query);
}

class SearchDemoDataSourceImpl implements SearchDemoDataSource {
  final _all = List.generate(
    12,
    (i) => PractitionerSearchResult(
      id: 'p${i + 1}',
      name: 'Dr Practicien ${i + 1}',
      specialty: i.isEven ? 'Ophtalmologiste' : 'Médecin généraliste',
      address: '75019 Paris • Avenue Secrétan',
      sector: 'Secteur 1',
      nextAvailabilityLabel: i == 0 ? 'Aujourd’hui' : 'Cette semaine',
      distanceLabel: i == 0 ? '1,2 km' : null,
    ),
  );

  @override
  List<PractitionerSearchResult> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return List.unmodifiable(_all);
    return List.unmodifiable(
      _all.where(
        (p) =>
            p.name.toLowerCase().contains(q) ||
            p.specialty.toLowerCase().contains(q),
      ),
    );
  }
}

