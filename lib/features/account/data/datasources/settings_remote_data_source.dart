import '../../../../core/network/api_client.dart';
import '../../domain/entities/app_settings.dart';
import 'settings_local_data_source.dart';

/// Remote implementation of [SettingsLocalDataSource] backed by the Dokal
/// backend REST API.
class SettingsRemoteDataSourceImpl implements SettingsLocalDataSource {
  SettingsRemoteDataSourceImpl({required this.api});

  final ApiClient api;

  @override
  AppSettings getSettings() => throw UnimplementedError('Use getSettingsAsync');

  @override
  Future<void> saveSettings(AppSettings settings) =>
      throw UnimplementedError('Use saveSettingsAsync');

  Future<AppSettings> getSettingsAsync() async {
    final json = await api.get('/api/v1/settings') as Map<String, dynamic>;
    return AppSettings(
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      remindersEnabled: json['reminders_enabled'] as bool? ?? true,
    );
  }

  Future<void> saveSettingsAsync(AppSettings settings) async {
    await api.patch(
      '/api/v1/settings',
      data: {
        'notifications_enabled': settings.notificationsEnabled,
        'reminders_enabled': settings.remindersEnabled,
      },
    );
  }
}
