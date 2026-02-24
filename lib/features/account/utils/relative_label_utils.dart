import '../domain/entities/relative.dart';

/// Retourne le libellé localisé d'un proche (relation + année).
String relativeDisplayLabel(dynamic l10n, Relative r) {
  final rel = _localizedRelation(l10n, r.relation);
  if (rel.isEmpty) return r.label;
  final year = r.dateOfBirth != null && r.dateOfBirth!.length >= 4
      ? int.tryParse(r.dateOfBirth!.substring(0, 4))
      : null;
  return year != null ? l10n.relativeLabel(rel, year) : rel;
}

String _localizedRelation(dynamic l10n, String? key) {
  if (key == null || key.isEmpty) return '';
  switch (key.toLowerCase()) {
    case 'child':
      return l10n.relativeChild;
    case 'parent':
      return l10n.relativeParent;
    case 'spouse':
      return l10n.relativeSpouse;
    case 'sibling':
      return l10n.relativeSibling;
    case 'other':
      return l10n.relativeOther;
    default:
      return key;
  }
}
