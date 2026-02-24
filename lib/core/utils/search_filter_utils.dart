// Utilitaires pour les filtres de recherche (spécialité, kupat holim, date).
// Les options du filtre sont en hébreu (UI). L'API peut retourner des valeurs
// en français, hébreu ou anglais. Ces mappings permettent la correspondance.

/// Mapping: clé du filtre spécialité (l10n) -> valeurs possibles de l'API (toutes langues)
const Map<String, Set<String>> _specialtyFilterKeyToApiValues = {
  'specialty_family': {
    'רופא משפחה', 'רופאת משפחה', 'Médecin de famille', 'Family physician',
    'Médico de familia', 'የቤተሰብ ሐኪም', 'Врач общей практики',
  },
  'specialty_ophthalmologist': {
    'רופא עיניים', 'רופאת עיניים', 'Ophtalmologue', 'Ophthalmologist',
    'Oftalmólogo', 'የዓይን ሐኪም', 'Офтальмолог',
  },
  'specialty_cardiologist': {
    'קרדיולוג', 'Cardiologue', 'Cardiologist', 'Cardiólogo',
    'የልብ ሐኪም', 'Кардиолог',
  },
  'specialty_dermatologist': {
    'רופא עור', 'רופאת עור', 'Dermatologue', 'Dermatologist',
    'Dermatólogo', 'የቆዳ ሐኪም', 'Дерматолог',
  },
  'specialty_pediatrician': {
    'רופא ילדים', 'Pédiatre', 'Pediatrician', 'Pediatra',
    'የህፃናት ሐኪም', 'Педиатр',
  },
  'specialty_gynecologist': {
    'גינקולוגית', 'Gynécologue', 'Gynecologist', 'Ginecólogo',
    'የሴቶች ጤና ሐኪም', 'Гинеколог',
  },
  'specialty_orthopedist': {
    'אורטופד', 'Orthopédiste', 'Orthopedist', 'Ortopedista',
    'የአጥንት ሐኪም', 'Ортопед',
  },
  'specialty_neurologist': {
    'נוירולוג', 'Neurologue', 'Neurologist', 'Neurólogo',
    'የነርቭ ሐኪም', 'Невролог',
  },
  'specialty_internal': {
    'רופא פנימי', 'Médecin interne', 'Internal medicine', 'Medicina interna',
    'የውስጥ ሐኪም', 'Терапевт',
  },
  'specialty_psychiatrist': {
    'פסיכיאטר', 'פסיכיאטרית', 'Psychiatre', 'Psychiatrist',
    'Psiquiatra', 'የአእምሮ ሐኪም', 'Психиатр',
  },
};

/// Mapping: clé l10n -> getter name sur AppLocalizations
const Map<String, String> _specialtyKeyToL10nGetter = {
  'specialty_family': 'searchFilterSpecialtyFamily',
  'specialty_ophthalmologist': 'searchFilterSpecialtyOphthalmologist',
  'specialty_cardiologist': 'searchFilterSpecialtyCardiologist',
  'specialty_dermatologist': 'searchFilterSpecialtyDermatologist',
  'specialty_pediatrician': 'searchFilterSpecialtyPediatrician',
  'specialty_gynecologist': 'searchFilterSpecialtyGynecologist',
  'specialty_orthopedist': 'searchFilterSpecialtyOrthopedist',
  'specialty_neurologist': 'searchFilterSpecialtyNeurologist',
  'specialty_internal': 'searchFilterSpecialtyInternal',
  'specialty_psychiatrist': 'searchFilterSpecialtyPsychiatrist',
};

/// Retourne le libellé localisé d'une spécialité API pour l'affichage.
/// [apiSpecialty] : valeur provenant de l'API (hébreu, français, anglais, etc.)
/// [l10n] : instance AppLocalizations (context.l10n)
/// Si non reconnue, retourne [apiSpecialty] tel quel ou [commonUnknown] si vide.
String specialtyToDisplayLabel(String? apiSpecialty, dynamic l10n) {
  if (apiSpecialty == null || apiSpecialty.trim().isEmpty) {
    return l10n.commonUnknown;
  }
  final specNorm = apiSpecialty.trim();
  for (final entry in _specialtyFilterKeyToApiValues.entries) {
    if (entry.value.contains(specNorm)) {
      final getter = _specialtyKeyToL10nGetter[entry.key];
      if (getter != null) {
        switch (getter) {
          case 'searchFilterSpecialtyFamily':
            return l10n.searchFilterSpecialtyFamily;
          case 'searchFilterSpecialtyOphthalmologist':
            return l10n.searchFilterSpecialtyOphthalmologist;
          case 'searchFilterSpecialtyCardiologist':
            return l10n.searchFilterSpecialtyCardiologist;
          case 'searchFilterSpecialtyDermatologist':
            return l10n.searchFilterSpecialtyDermatologist;
          case 'searchFilterSpecialtyPediatrician':
            return l10n.searchFilterSpecialtyPediatrician;
          case 'searchFilterSpecialtyGynecologist':
            return l10n.searchFilterSpecialtyGynecologist;
          case 'searchFilterSpecialtyOrthopedist':
            return l10n.searchFilterSpecialtyOrthopedist;
          case 'searchFilterSpecialtyNeurologist':
            return l10n.searchFilterSpecialtyNeurologist;
          case 'searchFilterSpecialtyInternal':
            return l10n.searchFilterSpecialtyInternal;
          case 'searchFilterSpecialtyPsychiatrist':
            return l10n.searchFilterSpecialtyPsychiatrist;
          default:
            return specNorm;
        }
      }
    }
  }
  // "לא ידוע" / "Unknown" etc. (toutes langues)
  const unknownVariants = {
    'לא ידוע', 'Unknown', 'Inconnu', 'Desconocido', 'ያልታወቀ', 'Неизвестно',
    'Unknown specialty', 'Spécialité inconnue',
  };
  if (unknownVariants.contains(specNorm)) {
    return l10n.commonUnknown;
  }
  return specNorm;
}

/// Vérifie si la spécialité du praticien correspond au filtre (clé l10n).
bool specialtyMatchesFilter(String? filterKey, String? practitionerSpecialty) {
  if (filterKey == null || filterKey.isEmpty) return true;
  if (practitionerSpecialty == null || practitionerSpecialty.isEmpty) return false;

  final apiValues = _specialtyFilterKeyToApiValues[filterKey];
  if (apiValues == null) {
    return practitionerSpecialty.trim().toLowerCase() ==
        filterKey.trim().toLowerCase();
  }

  final specNorm = practitionerSpecialty.trim();
  return apiValues.any((v) => v == specNorm);
}

/// Le filtre kupat utilise directement la valeur API (sector): Clalit, Maccabi, etc.
/// L'affichage est géré par l10n (kupatClalit, kupatMaccabi, etc.)
bool kupatMatchesFilter(String? filterKupat, String? practitionerSector) {
  if (filterKupat == null || filterKupat.isEmpty) return true;
  if (practitionerSector == null || practitionerSector.isEmpty) return false;
  return practitionerSector.trim() == filterKupat.trim();
}

/// Vérifie si la prochaine dispo (nextAvailabilityLabel "YYYY-MM-DD HH:MM")
/// correspond au filtre de date.
bool dateMatchesFilter(String? filterDate, String? nextAvailabilityLabel) {
  if (filterDate == null || filterDate.isEmpty) return true;
  if (nextAvailabilityLabel == null || nextAvailabilityLabel.isEmpty) {
    return false;
  }

  DateTime? slotDate;
  final parts = nextAvailabilityLabel.trim().split(RegExp(r'\s+'));
  final datePart = parts.isNotEmpty ? parts.first : null;
  if (datePart != null && datePart.length >= 10) {
    slotDate = DateTime.tryParse(datePart);
  }
  if (slotDate == null) return false;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final slotDay = DateTime(slotDate.year, slotDate.month, slotDate.day);

  switch (filterDate) {
    case 'today':
      return slotDay == today;
    case 'tomorrow':
      return slotDay == today.add(const Duration(days: 1));
    case 'this_week':
      final daysUntilSunday = 7 - today.weekday;
      final weekEnd = today.add(Duration(days: daysUntilSunday));
      return !slotDay.isBefore(today) && !slotDay.isAfter(weekEnd);
    case 'next_week':
      final nextWeekStart = today.add(Duration(days: 8 - today.weekday));
      final nextWeekEnd = nextWeekStart.add(const Duration(days: 6));
      return !slotDay.isBefore(nextWeekStart) && !slotDay.isAfter(nextWeekEnd);
    default:
      return true;
  }
}
