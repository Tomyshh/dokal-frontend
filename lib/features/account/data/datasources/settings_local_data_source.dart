import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/app_settings.dart';

abstract class SettingsLocalDataSource {
  AppSettings getSettings();
  Future<void> saveSettings(AppSettings settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsLocalDataSourceImpl({required this.prefs});

  static const _kNotifications = 'settings_notifications_enabled';
  static const _kReminders = 'settings_reminders_enabled';

  final SharedPreferences prefs;

  @override
  AppSettings getSettings() {
    return AppSettings(
      notificationsEnabled: prefs.getBool(_kNotifications) ?? true,
      remindersEnabled: prefs.getBool(_kReminders) ?? true,
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final ok1 = await prefs.setBool(_kNotifications, settings.notificationsEnabled);
    final ok2 = await prefs.setBool(_kReminders, settings.remindersEnabled);
    if (!ok1 || !ok2) {
      throw const CacheException('Impossible de sauvegarder les paramètres.');
    }
  }
}

