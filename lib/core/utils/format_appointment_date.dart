import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/l10n.dart';

/// Formate une date de rendez-vous au format "d MMMM yyyy" avec indication
/// relative si aujourd'hui ou demain : "22 février 2026 (aujourd'hui)".
///
/// Si [dateLabel] est au format ISO (YYYY-MM-DD), on parse et formate.
/// Sinon, on retourne [dateLabel] tel quel (ex. données démo).
String formatAppointmentDateLabel(BuildContext context, String dateLabel) {
  final l10n = context.l10n;
  final locale = Localizations.localeOf(context);
  final localeStr = locale.toLanguageTag();

  final parsed = DateTime.tryParse(dateLabel);
  if (parsed == null) return dateLabel;

  final dateOnly = DateTime(parsed.year, parsed.month, parsed.day);
  final today = DateTime.now();
  final todayOnly = DateTime(today.year, today.month, today.day);
  final tomorrowOnly = todayOnly.add(const Duration(days: 1));

  final formatter = DateFormat('d MMMM yyyy', localeStr);
  final formatted = formatter.format(dateOnly);

  if (dateOnly == todayOnly) {
    return '$formatted (${l10n.searchFilterDateToday})';
  }
  if (dateOnly == tomorrowOnly) {
    return '$formatted (${l10n.searchFilterDateTomorrow})';
  }
  return formatted;
}
