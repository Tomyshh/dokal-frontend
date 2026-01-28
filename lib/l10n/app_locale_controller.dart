import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../injection_container.dart';

class AppLocaleController {
  AppLocaleController._();

  static const _prefsKey = 'app_locale';

  /// Langue actuellement forcée par l’app (par défaut: hébreu).
  /// Si l’utilisateur choisit une langue, elle est persistée.
  static final ValueNotifier<Locale> locale = ValueNotifier(const Locale('he'));

  static Future<void> init() async {
    final prefs = sl<SharedPreferences>();
    final code = prefs.getString(_prefsKey);
    if (code == null || code.isEmpty) return;
    locale.value = Locale(code);
  }

  static Future<void> setLocale(Locale newLocale) async {
    locale.value = newLocale;
    final prefs = sl<SharedPreferences>();
    await prefs.setString(_prefsKey, newLocale.languageCode);
  }
}
