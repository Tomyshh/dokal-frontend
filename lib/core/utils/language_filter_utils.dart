/// Utilitaires pour le filtrage par langue.
///
/// L'API peut retourner des langues sous différents formats :
/// - codes ISO (he, fr, en)
/// - noms en anglais (Hebrew, French, English)
/// - noms localisés (עברית, Français, English)
/// Le filtre utilise des codes ISO. Cette map permet de faire la correspondance.
const Map<String, Set<String>> _languageCodeToVariants = {
  'he': {
    'he', 'iw', 'heb', 'hebrew', 'hebreu',
    'עברית', // Hébreu en hébreu
  },
  'fr': {
    'fr', 'fra', 'french', 'français', 'francais',
    'צרפתית', // Français en hébreu
  },
  'en': {
    'en', 'eng', 'english',
    'אנגלית', // Anglais en hébreu
  },
  'ru': {
    'ru', 'rus', 'russian',
    'רוסית', 'Русский', 'русский', // Russe en hébreu et cyrillique
  },
  'es': {
    'es', 'spa', 'spanish', 'español', 'espanol',
    'ספרדית', // Espagnol en hébreu
  },
  'am': {
    'am', 'amh', 'amharic',
    'አማርኛ', // Amharique
  },
  'ar': {
    'ar', 'ara', 'arabic',
    'ערבית', 'عربية', // Arabe en hébreu et arabe
  },
};

/// Vérifie si une langue du praticien correspond au filtre (code ISO).
bool languageMatchesFilter(String? filterCode, List<String>? practitionerLanguages) {
  if (filterCode == null || filterCode.isEmpty) return true;
  if (practitionerLanguages == null || practitionerLanguages.isEmpty) return false;

  final variants = _languageCodeToVariants[filterCode.toLowerCase()];
  if (variants == null) {
    // Code inconnu : comparaison exacte en fallback
    return practitionerLanguages.any(
      (l) => l.trim().toLowerCase() == filterCode.trim().toLowerCase(),
    );
  }

  final filterNorm = filterCode.trim().toLowerCase();
  return practitionerLanguages.any((l) {
    final langNorm = l.trim().toLowerCase();
    if (langNorm.isEmpty) return false;
    return variants.contains(langNorm) || langNorm == filterNorm;
  });
}
