import '../../domain/entities/practitioner_search_result.dart';

abstract class SearchDemoDataSource {
  List<PractitionerSearchResult> search(String query);
}

class SearchDemoDataSourceImpl implements SearchDemoDataSource {
  // URLs d'avatars professionnels (images libres de droits)
  static const List<String> _avatarUrls = [
    'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=150&h=150&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=150&h=150&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=150&h=150&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1594824476967-48c8b964273f?w=150&h=150&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=150&h=150&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1651008376811-b90baee60c1f?w=150&h=150&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=150&h=150&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1527613426441-4da17471b66d?w=150&h=150&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1666214280557-f1b5022eb634?w=150&h=150&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1618498082410-b4aa22193b38?w=150&h=150&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=150&h=150&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1550831107-1553da8c8464?w=150&h=150&fit=crop&crop=face',
  ];

  // Données mock avec des noms et adresses israéliennes authentiques
  static const List<_MockPractitioner> _mockData = [
    _MockPractitioner(
      name: 'ד"ר יוסף כהן',
      specialty: 'רופא עיניים',
      address: 'רחוב דיזנגוף 120, תל אביב',
      sector: 'קופ"ח כללית',
      availability: 'היום',
      distanceLabel: '0.8 ק"מ',
      distanceKm: 0.8,
      availabilityOrder: 0,
      languages: ['he', 'en'],
    ),
    _MockPractitioner(
      name: 'ד"ר שרה לוי',
      specialty: 'רופאת משפחה',
      address: 'שדרות רוטשילד 45, תל אביב',
      sector: 'קופ"ח מכבי',
      availability: 'מחר',
      distanceLabel: '1.2 ק"מ',
      distanceKm: 1.2,
      availabilityOrder: 1,
      languages: ['he', 'fr'],
    ),
    _MockPractitioner(
      name: 'ד"ר אברהם גולדשטיין',
      specialty: 'קרדיולוג',
      address: 'רחוב הרצל 78, ירושלים',
      sector: 'קופ"ח מאוחדת',
      availability: 'השבוע',
      distanceLabel: '2.5 ק"מ',
      distanceKm: 2.5,
      availabilityOrder: 2,
      languages: ['he', 'en', 'ru'],
    ),
    _MockPractitioner(
      name: 'ד"ר מיכל ברק',
      specialty: 'רופאת עור',
      address: 'שדרות בן גוריון 32, רמת גן',
      sector: 'קופ"ח לאומית',
      availability: 'היום',
      distanceLabel: '1.5 ק"מ',
      distanceKm: 1.5,
      availabilityOrder: 0,
      languages: ['he'],
    ),
    _MockPractitioner(
      name: 'ד"ר דוד פרידמן',
      specialty: 'רופא ילדים',
      address: 'רחוב ויצמן 56, חיפה',
      sector: 'קופ"ח כללית',
      availability: 'מחר',
      distanceLabel: '45 ק"מ',
      distanceKm: 45.0,
      availabilityOrder: 1,
      languages: ['he', 'en', 'fr'],
    ),
    _MockPractitioner(
      name: 'ד"ר רחל אזולאי',
      specialty: 'גינקולוגית',
      address: 'רחוב יפו 89, תל אביב',
      sector: 'קופ"ח מכבי',
      availability: 'השבוע',
      distanceLabel: '3.0 ק"מ',
      distanceKm: 3.0,
      availabilityOrder: 2,
      languages: ['he', 'ar'],
    ),
    _MockPractitioner(
      name: 'ד"ר משה שפירא',
      specialty: 'אורטופד',
      address: 'שדרות ההגנה 15, באר שבע',
      sector: 'קופ"ח מאוחדת',
      availability: 'היום',
      distanceLabel: '85 ק"מ',
      distanceKm: 85.0,
      availabilityOrder: 0,
      languages: ['he', 'en'],
    ),
    _MockPractitioner(
      name: 'ד"ר נעמי רוזנברג',
      specialty: 'רופאת משפחה',
      address: 'רחוב סוקולוב 67, הרצליה',
      sector: 'קופ"ח כללית',
      availability: 'שבוע הבא',
      distanceLabel: '4.2 ק"מ',
      distanceKm: 4.2,
      availabilityOrder: 3,
      languages: ['he', 'ru'],
    ),
    _MockPractitioner(
      name: 'ד"ר יעקב אלון',
      specialty: 'נוירולוג',
      address: 'רחוב אלנבי 102, תל אביב',
      sector: 'קופ"ח לאומית',
      availability: 'השבוע',
      distanceLabel: '0.5 ק"מ',
      distanceKm: 0.5,
      availabilityOrder: 2,
      languages: ['he', 'en', 'es'],
    ),
    _MockPractitioner(
      name: 'ד"ר טלי מזרחי',
      specialty: 'רופאת עיניים',
      address: 'שדרות ירושלים 23, רעננה',
      sector: 'קופ"ח מכבי',
      availability: 'היום',
      distanceLabel: '5.0 ק"מ',
      distanceKm: 5.0,
      availabilityOrder: 0,
      languages: ['he', 'fr'],
    ),
    _MockPractitioner(
      name: 'ד"ר אהרון ביטון',
      specialty: 'רופא פנימי',
      address: 'רחוב בלפור 41, נתניה',
      sector: 'קופ"ח מאוחדת',
      availability: 'מחר',
      distanceLabel: '25 ק"מ',
      distanceKm: 25.0,
      availabilityOrder: 1,
      languages: ['he', 'am'],
    ),
    _MockPractitioner(
      name: 'ד"ר הילה דהן',
      specialty: 'פסיכיאטרית',
      address: 'רחוב קינג ג׳ורג׳ 58, ירושלים',
      sector: 'קופ"ח כללית',
      availability: 'שבוע הבא',
      distanceLabel: '1.8 ק"מ',
      distanceKm: 1.8,
      availabilityOrder: 3,
      languages: ['he', 'en'],
    ),
  ];

  List<PractitionerSearchResult> _buildAll() {
    return _mockData.asMap().entries.map((entry) {
      final i = entry.key;
      final p = entry.value;
      return PractitionerSearchResult(
        id: 'p${i + 1}',
        name: p.name,
        specialty: p.specialty,
        address: p.address,
        sector: p.sector,
        nextAvailabilityLabel: p.availability,
        distanceLabel: p.distanceLabel,
        avatarUrl: _avatarUrls[i % _avatarUrls.length],
        distanceKm: p.distanceKm,
        availabilityOrder: p.availabilityOrder,
        rating: 4.0 + (i % 5) * 0.1,
        reviewCount: 100 + i * 300,
        priceMinAgorot: 25000 + (i % 3) * 5000,
        priceMaxAgorot: 30000 + (i % 3) * 5000,
        languages: p.languages,
      );
    }).toList();
  }

  @override
  List<PractitionerSearchResult> search(String query) {
    final all = _buildAll();
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return List.unmodifiable(all);
    return List.unmodifiable(
      all.where(
        (p) =>
            p.name.toLowerCase().contains(q) ||
            p.specialty.toLowerCase().contains(q) ||
            p.address.toLowerCase().contains(q),
      ),
    );
  }
}

class _MockPractitioner {
  const _MockPractitioner({
    required this.name,
    required this.specialty,
    required this.address,
    required this.sector,
    required this.availability,
    required this.distanceLabel,
    required this.distanceKm,
    required this.availabilityOrder,
    this.languages,
  });

  final String name;
  final String specialty;
  final String address;
  final String sector;
  final String availability;
  final String distanceLabel;
  final double distanceKm;
  final int availabilityOrder;
  final List<String>? languages;
}
