import '../../domain/entities/practitioner_profile.dart';

abstract class PractitionerDemoDataSource {
  PractitionerProfile getById(String id);
}

class PractitionerDemoDataSourceImpl implements PractitionerDemoDataSource {
  // Données des praticiens liées aux données de recherche
  static final Map<String, _PractitionerData> _practitionersData = {
    'p1': _PractitionerData(
      name: 'ד"ר יוסף כהן',
      specialty: 'רופא עיניים',
      address: 'רחוב דיזנגוף 120, תל אביב',
      sector: 'קופ"ח כללית',
      avatarUrl: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400&h=400&fit=crop&crop=face',
      about: 'ד"ר יוסף כהן הוא רופא עיניים מומחה עם ניסיון של למעלה מ-15 שנה. הוא מתמחה בטיפול במחלות עיניים, ניתוחי קטרקט ולייזר לתיקון ראייה. בוגר הפקולטה לרפואה באוניברסיטת תל אביב.',
      phone: '03-1234567',
      email: 'dr.cohen@clinic.co.il',
      languages: ['עברית', 'אנגלית', 'רוסית'],
      education: 'אוניברסיטת תל אביב',
      yearsOfExperience: 15,
      availabilities: ['היום • 14:30', 'היום • 16:00', 'מחר • 09:15', 'מחר • 11:30'],
    ),
    'p2': _PractitionerData(
      name: 'ד"ר שרה לוי',
      specialty: 'רופאת משפחה',
      address: 'שדרות רוטשילד 45, תל אביב',
      sector: 'קופ"ח מכבי',
      avatarUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&h=400&fit=crop&crop=face',
      about: 'ד"ר שרה לוי היא רופאת משפחה עם גישה הוליסטית לטיפול רפואי. היא מאמינה בחשיבות הקשר בין רופא למטופל ובמתן טיפול מותאם אישית לכל מטופל.',
      phone: '03-2345678',
      email: 'dr.levi@maccabi.co.il',
      languages: ['עברית', 'אנגלית', 'צרפתית'],
      education: 'האוניברסיטה העברית',
      yearsOfExperience: 12,
      availabilities: ['מחר • 08:00', 'מחר • 10:30', 'השבוע • 14:00'],
    ),
    'p3': _PractitionerData(
      name: 'ד"ר אברהם גולדשטיין',
      specialty: 'קרדיולוג',
      address: 'רחוב הרצל 78, ירושלים',
      sector: 'קופ"ח מאוחדת',
      avatarUrl: 'https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=400&h=400&fit=crop&crop=face',
      about: 'ד"ר אברהם גולדשטיין הוא קרדיולוג בכיר עם התמחות בטיפול במחלות לב ובאבחון מתקדם. הוא מנהל את מחלקת הקרדיולוגיה בבית החולים הדסה.',
      phone: '02-3456789',
      email: 'dr.goldstein@hadassah.org.il',
      languages: ['עברית', 'אנגלית', 'יידיש'],
      education: 'אוניברסיטת בר-אילן',
      yearsOfExperience: 22,
      availabilities: ['השבוע • 09:00', 'השבוע • 13:30', 'שבוע הבא • 10:00'],
    ),
    'p4': _PractitionerData(
      name: 'ד"ר מיכל ברק',
      specialty: 'רופאת עור',
      address: 'שדרות בן גוריון 32, רמת גן',
      sector: 'קופ"ח לאומית',
      avatarUrl: 'https://images.unsplash.com/photo-1594824476967-48c8b964273f?w=400&h=400&fit=crop&crop=face',
      about: 'ד"ר מיכל ברק היא דרמטולוגית מומחית עם התמחות בטיפולים אסתטיים ובמחלות עור. היא משלבת גישה רפואית מקצועית עם הבנה לצרכים האסתטיים של המטופלים.',
      phone: '03-4567890',
      email: 'dr.barak@leumit.co.il',
      languages: ['עברית', 'אנגלית'],
      education: 'הטכניון',
      yearsOfExperience: 10,
      availabilities: ['היום • 15:00', 'היום • 17:30', 'מחר • 09:00'],
    ),
    'p5': _PractitionerData(
      name: 'ד"ר דוד פרידמן',
      specialty: 'רופא ילדים',
      address: 'רחוב ויצמן 56, חיפה',
      sector: 'קופ"ח כללית',
      avatarUrl: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=400&h=400&fit=crop&crop=face',
      about: 'ד"ר דוד פרידמן הוא רופא ילדים ותיק ואהוב, המתמחה בטיפול בתינוקות, פעוטות וילדים. הוא ידוע בסבלנותו ובגישתו החמה לילדים ולהוריהם.',
      phone: '04-5678901',
      email: 'dr.friedman@clalit.org.il',
      languages: ['עברית', 'אנגלית', 'גרמנית'],
      education: 'אוניברסיטת חיפה',
      yearsOfExperience: 18,
      availabilities: ['מחר • 08:30', 'מחר • 11:00', 'השבוע • 14:30'],
    ),
    'p6': _PractitionerData(
      name: 'ד"ר רחל אזולאי',
      specialty: 'גינקולוגית',
      address: 'רחוב יפו 89, תל אביב',
      sector: 'קופ"ח מכבי',
      avatarUrl: 'https://images.unsplash.com/photo-1651008376811-b90baee60c1f?w=400&h=400&fit=crop&crop=face',
      about: 'ד"ר רחל אזולאי היא גינקולוגית מומחית עם התמחות בבריאות האישה ומעקב הריון. היא מאמינה בחשיבות ההקשבה לנשים ובמתן מענה מקיף לכל צרכיהן הרפואיים.',
      phone: '03-6789012',
      email: 'dr.azoulay@maccabi.co.il',
      languages: ['עברית', 'אנגלית', 'ספרדית'],
      education: 'אוניברסיטת בן-גוריון',
      yearsOfExperience: 14,
      availabilities: ['השבוע • 10:00', 'השבוע • 15:30', 'שבוע הבא • 09:00'],
    ),
    'p7': _PractitionerData(
      name: 'ד"ר משה שפירא',
      specialty: 'אורטופד',
      address: 'שדרות ההגנה 15, באר שבע',
      sector: 'קופ"ח מאוחדת',
      avatarUrl: 'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=400&h=400&fit=crop&crop=face',
      about: 'ד"ר משה שפירא הוא מנתח אורטופד מומחה עם התמחות בניתוחי מפרקים והחלפת ברכיים וירכיים. הוא משלב טכניקות כירורגיות מתקדמות עם גישה שמרנית כאשר אפשר.',
      phone: '08-7890123',
      email: 'dr.shapira@meuhedet.co.il',
      languages: ['עברית', 'אנגלית', 'ערבית'],
      education: 'אוניברסיטת תל אביב',
      yearsOfExperience: 20,
      availabilities: ['היום • 11:00', 'היום • 14:00', 'מחר • 10:00'],
    ),
    'p8': _PractitionerData(
      name: 'ד"ר נעמי רוזנברג',
      specialty: 'רופאת משפחה',
      address: 'רחוב סוקולוב 67, הרצליה',
      sector: 'קופ"ח כללית',
      avatarUrl: 'https://images.unsplash.com/photo-1527613426441-4da17471b66d?w=400&h=400&fit=crop&crop=face',
      about: 'ד"ר נעמי רוזנברג היא רופאת משפחה עם גישה מקיפה לרפואה מונעת. היא מתמקדת בקידום אורח חיים בריא ובמניעת מחלות כרוניות.',
      phone: '09-8901234',
      email: 'dr.rosenberg@clalit.org.il',
      languages: ['עברית', 'אנגלית'],
      education: 'האוניברסיטה העברית',
      yearsOfExperience: 8,
      availabilities: ['שבוע הבא • 09:00', 'שבוע הבא • 13:00', 'שבוע הבא • 16:00'],
    ),
    'p9': _PractitionerData(
      name: 'ד"ר יעקב אלון',
      specialty: 'נוירולוג',
      address: 'רחוב אלנבי 102, תל אביב',
      sector: 'קופ"ח לאומית',
      avatarUrl: 'https://images.unsplash.com/photo-1666214280557-f1b5022eb634?w=400&h=400&fit=crop&crop=face',
      about: 'ד"ר יעקב אלון הוא נוירולוג מומחה עם התמחות במחלות עצבים ובאבחון מצבים נוירולוגיים מורכבים. הוא משמש כיועץ בכיר במרכז הרפואי איכילוב.',
      phone: '03-9012345',
      email: 'dr.alon@leumit.co.il',
      languages: ['עברית', 'אנגלית', 'צרפתית'],
      education: 'אוניברסיטת תל אביב',
      yearsOfExperience: 16,
      availabilities: ['השבוע • 11:00', 'השבוע • 14:30', 'שבוע הבא • 10:00'],
    ),
    'p10': _PractitionerData(
      name: 'ד"ר טלי מזרחי',
      specialty: 'רופאת עיניים',
      address: 'שדרות ירושלים 23, רעננה',
      sector: 'קופ"ח מכבי',
      avatarUrl: 'https://images.unsplash.com/photo-1618498082410-b4aa22193b38?w=400&h=400&fit=crop&crop=face',
      about: 'ד"ר טלי מזרחי היא רופאת עיניים מומחית עם התמחות בטיפול בגלאוקומה ובמחלות רשתית. היא משלבת טכנולוגיה מתקדמת באבחון וטיפול.',
      phone: '09-0123456',
      email: 'dr.mizrachi@maccabi.co.il',
      languages: ['עברית', 'אנגלית'],
      education: 'הטכניון',
      yearsOfExperience: 11,
      availabilities: ['היום • 09:30', 'היום • 12:00', 'מחר • 15:00'],
    ),
    'p11': _PractitionerData(
      name: 'ד"ר אהרון ביטון',
      specialty: 'רופא פנימי',
      address: 'רחוב בלפור 41, נתניה',
      sector: 'קופ"ח מאוחדת',
      avatarUrl: 'https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=400&h=400&fit=crop&crop=face',
      about: 'ד"ר אהרון ביטון הוא רופא פנימי בכיר עם התמחות באבחון מחלות מורכבות וטיפול במחלות כרוניות. הוא מנהל את המרפאה לרפואה פנימית בנתניה.',
      phone: '09-1234567',
      email: 'dr.biton@meuhedet.co.il',
      languages: ['עברית', 'אנגלית', 'צרפתית'],
      education: 'אוניברסיטת בן-גוריון',
      yearsOfExperience: 19,
      availabilities: ['מחר • 08:00', 'מחר • 11:30', 'השבוע • 14:00'],
    ),
    'p12': _PractitionerData(
      name: 'ד"ר הילה דהן',
      specialty: 'פסיכיאטרית',
      address: 'רחוב קינג ג׳ורג׳ 58, ירושלים',
      sector: 'קופ"ח כללית',
      avatarUrl: 'https://images.unsplash.com/photo-1550831107-1553da8c8464?w=400&h=400&fit=crop&crop=face',
      about: 'ד"ר הילה דהן היא פסיכיאטרית מומחית עם התמחות בטיפול בחרדה, דיכאון והפרעות מצב רוח. היא משלבת טיפול תרופתי עם פסיכותרפיה.',
      phone: '02-2345678',
      email: 'dr.dahan@clalit.org.il',
      languages: ['עברית', 'אנגלית', 'ערבית'],
      education: 'האוניברסיטה העברית',
      yearsOfExperience: 13,
      availabilities: ['שבוע הבא • 10:00', 'שבוע הבא • 14:00', 'שבוע הבא • 17:00'],
    ),
  };

  @override
  PractitionerProfile getById(String id) {
    final data = _practitionersData[id];
    
    if (data == null) {
      // Fallback pour les IDs non reconnus
      return PractitionerProfile(
        id: id,
        name: 'רופא לא נמצא',
        specialty: 'לא ידוע',
        address: 'כתובת לא זמינה',
        about: 'מידע על הרופא אינו זמין כרגע.',
        nextAvailabilities: const [],
      );
    }
    
    return PractitionerProfile(
      id: id,
      name: data.name,
      specialty: data.specialty,
      address: data.address,
      about: data.about,
      nextAvailabilities: data.availabilities,
      avatarUrl: data.avatarUrl,
      sector: data.sector,
      phone: data.phone,
      email: data.email,
      languages: data.languages,
      education: data.education,
      yearsOfExperience: data.yearsOfExperience,
    );
  }
}

class _PractitionerData {
  const _PractitionerData({
    required this.name,
    required this.specialty,
    required this.address,
    required this.sector,
    required this.avatarUrl,
    required this.about,
    required this.phone,
    required this.email,
    required this.languages,
    required this.education,
    required this.yearsOfExperience,
    required this.availabilities,
  });

  final String name;
  final String specialty;
  final String address;
  final String sector;
  final String avatarUrl;
  final String about;
  final String phone;
  final String email;
  final List<String> languages;
  final String education;
  final int yearsOfExperience;
  final List<String> availabilities;
}
