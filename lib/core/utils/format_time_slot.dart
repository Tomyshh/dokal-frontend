/// Convertit une chaîne d'heure (12h ou 24h) en format 24h "HH:mm".
/// Gère : "18:00", "18:00:00", "06:00 PM", "2024-02-22T18:00:00", etc.
String formatTimeTo24h(String time) {
  final t = time.trim();
  if (t.isEmpty) return '--:--';

  // Format ISO (ex: "2024-02-22T14:15:00" ou "14:15:00.000Z")
  final isoMatch = RegExp(r'T(\d{1,2}):(\d{2})').firstMatch(t);
  if (isoMatch != null) {
    final h = int.tryParse(isoMatch.group(1)!) ?? 0;
    final m = int.tryParse(isoMatch.group(2)!) ?? 0;
    if (h >= 0 && h <= 23 && m >= 0 && m <= 59) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
    }
  }

  // Format 12h EN PREMIER (h:mm AM/PM) pour éviter de confondre "02:15 PM" avec du 24h
  final match12 = RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM)\s*$', caseSensitive: false)
      .firstMatch(t);
  if (match12 != null) {
    var h = int.tryParse(match12.group(1)!) ?? 0;
    final m = int.tryParse(match12.group(2)!) ?? 0;
    final ampm = (match12.group(3) ?? '').toUpperCase();
    if (ampm == 'PM' && h != 12) h += 12;
    if (ampm == 'AM' && h == 12) h = 0;
    if (h >= 0 && h <= 23 && m >= 0 && m <= 59) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
    }
  }

  // Déjà en 24h (HH:mm ou HH:mm:ss)
  final match24 = RegExp(r'^(\d{1,2}):(\d{2})(?::(\d{2}))?(?:\.\d+)?\s*$').firstMatch(t);
  if (match24 != null) {
    final h = int.tryParse(match24.group(1)!) ?? 0;
    final m = int.tryParse(match24.group(2)!) ?? 0;
    if (h >= 0 && h <= 23 && m >= 0 && m <= 59) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
    }
  }

  // Fallback : extraire HH:mm au début (ex: "18:00:00" ou "18:00 xxx")
  final fallbackMatch = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(t);
  if (fallbackMatch != null) {
    final h = int.tryParse(fallbackMatch.group(1)!) ?? 0;
    final m = int.tryParse(fallbackMatch.group(2)!) ?? 0;
    if (h >= 0 && h <= 23 && m >= 0 && m <= 59) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
    }
  }

  return t;
}
