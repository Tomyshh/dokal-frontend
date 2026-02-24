// Utilitaires pour les filtres de recherche (spécialité, kupat holim, date).
// Les options du filtre sont en hébreu (UI). L'API peut retourner des valeurs
// en français, hébreu ou anglais. Ces mappings permettent la correspondance.

/// Mapping: clé du filtre spécialité (l10n) -> valeurs possibles de l'API
const Map<String, Set<String>> _specialtyFilterKeyToApiValues = {
  'specialty_family': {'רופא משפחה', 'רופאת משפחה', 'Médecin de famille', 'Family physician'},
  'specialty_ophthalmologist': {'רופא עיניים', 'רופאת עיניים', 'Ophtalmologue', 'Ophthalmologist'},
  'specialty_cardiologist': {'קרדיולוג', 'Cardiologue', 'Cardiologist'},
  'specialty_dermatologist': {'רופא עור', 'רופאת עור', 'Dermatologue', 'Dermatologist'},
  'specialty_pediatrician': {'רופא ילדים', 'Pédiatre', 'Pediatrician'},
  'specialty_gynecologist': {'גינקולוגית', 'Gynécologue', 'Gynecologist'},
  'specialty_orthopedist': {'אורטופד', 'Orthopédiste', 'Orthopedist'},
  'specialty_neurologist': {'נוירולוג', 'Neurologue', 'Neurologist'},
  'specialty_internal': {'רופא פנימי', 'Médecin interne', 'Internal medicine'},
  'specialty_psychiatrist': {'פסיכיאטר', 'פסיכיאטרית', 'Psychiatre', 'Psychiatrist'},
};

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
