import '../../l10n/l10n.dart';
import 'package:flutter/widgets.dart';

/// Clés stables des assureurs (valeur stockée en base).
const List<String> insuranceProviders = [
  'AIG',
  'איילון',
  'ביטוח חקלאי',
  'דקלה',
  'הראל',
  'הכשרה',
  'הפניקס',
  'כלל',
  'מגדל',
  'מנורה',
  'ביטוח ישיר',
  'שירביט',
  'שלמה',
  'שומרה',
];

/// Returns the translated display name for an insurance provider key.
String insuranceDisplayName(BuildContext context, String key) {
  final l10n = context.l10n;
  return switch (key) {
    'AIG' => l10n.insuranceAig,
    'איילון' => l10n.insuranceAyalon,
    'ביטוח חקלאי' => l10n.insuranceBituchHaklay,
    'דקלה' => l10n.insuranceDikla,
    'הראל' => l10n.insuranceHarel,
    'הכשרה' => l10n.insuranceHachshara,
    'הפניקס' => l10n.insuranceHaphenix,
    'כלל' => l10n.insuranceClal,
    'מגדל' => l10n.insuranceMigdal,
    'מנורה' => l10n.insuranceMenora,
    'ביטוח ישיר' => l10n.insuranceBituchYashir,
    'שירביט' => l10n.insuranceShirbit,
    'שלמה' => l10n.insuranceShlomo,
    'שומרה' => l10n.insuranceShomera,
    _ => key,
  };
}
