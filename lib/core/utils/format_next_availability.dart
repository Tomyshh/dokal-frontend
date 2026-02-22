import 'format_time_slot.dart';
import '../../l10n/app_localizations.dart';

/// Formate une date/heure de créneau (YYYY-MM-DD HH:MM) en libellé lisible :
/// - "Prochain: aujourd'hui à HH:MM" (format 24h)
/// - "Prochain: demain à HH:MM"
/// - "Prochain: dans X jours"
String formatNextAvailabilityLabel(String rawLabel, AppLocalizations l10n) {
  final parts = rawLabel.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty) return rawLabel;

  String dateStr = parts[0];
  // Rejoindre les parties restantes pour gérer "06:00 PM" etc.
  String timeStr = parts.length > 1 ? parts.sublist(1).join(' ') : '';

  timeStr = timeStr.isEmpty ? '--:--' : formatTimeTo24h(timeStr);

  DateTime? slotDate;
  try {
    slotDate = DateTime.parse(dateStr);
  } catch (_) {
    return rawLabel;
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final slotDay = DateTime(slotDate.year, slotDate.month, slotDate.day);

  final diffDays = slotDay.difference(today).inDays;

  if (diffDays == 0) {
    return l10n.searchNextToday(timeStr);
  } else if (diffDays == 1) {
    return l10n.searchNextTomorrow(timeStr);
  } else if (diffDays > 1) {
    return l10n.searchNextInDays(diffDays);
  }

  return rawLabel;
}
