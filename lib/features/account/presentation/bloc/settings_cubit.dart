import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/permissions/permissions_service.dart';
import '../../../../core/services/push_notification_service.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/save_settings.dart';
import '../../../notifications/domain/usecases/register_push_token.dart';
import '../../../notifications/domain/usecases/remove_push_token.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required GetSettings getSettings,
    required SaveSettings saveSettings,
    required PermissionsService permissionsService,
    required PushNotificationService pushNotificationService,
    required RegisterPushToken registerPushToken,
    required RemovePushToken removePushToken,
  }) : _getSettings = getSettings,
       _saveSettings = saveSettings,
       _permissionsService = permissionsService,
       _pushService = pushNotificationService,
       _registerPushToken = registerPushToken,
       _removePushToken = removePushToken,
       super(const SettingsState.initial());

  final GetSettings _getSettings;
  final SaveSettings _saveSettings;
  final PermissionsService _permissionsService;
  final PushNotificationService _pushService;
  final RegisterPushToken _registerPushToken;
  final RemovePushToken _removePushToken;

  Future<void> load() async {
    emit(state.copyWith(status: SettingsStatus.loading));
    final res = await _getSettings();
    res.fold(
      (f) => emit(
        state.copyWith(status: SettingsStatus.failure, error: f.message),
      ),
      (settings) => emit(
        state.copyWith(
          status: SettingsStatus.success,
          settings: settings,
          error: null,
        ),
      ),
    );
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    if (state.settings == null) return;

    if (enabled) {
      // 1. Permission système (Android 13+ / iOS)
      final systemGranted = await _permissionsService.requestNotifications();
      if (!systemGranted) {
        emit(
          state.copyWith(
            status: SettingsStatus.failure,
            error: 'Permission notifications refusée.',
          ),
        );
        final reverted = state.settings!.copyWith(notificationsEnabled: false);
        emit(
          state.copyWith(
            status: SettingsStatus.success,
            settings: reverted,
            error: null,
          ),
        );
        await _saveSettings(reverted);
        return;
      }
      // 2. Permission Firebase (iOS)
      final firebaseGranted = await _pushService.requestPermission();
      if (!firebaseGranted) {
        emit(
          state.copyWith(
            status: SettingsStatus.failure,
            error: 'Permission notifications refusée.',
          ),
        );
        final reverted = state.settings!.copyWith(notificationsEnabled: false);
        emit(
          state.copyWith(
            status: SettingsStatus.success,
            settings: reverted,
            error: null,
          ),
        );
        await _saveSettings(reverted);
        return;
      }
      // 3. Récupérer le token FCM et l'enregistrer côté backend
      final token = await _pushService.getToken();
      if (token != null) {
        final result = await _registerPushToken(
          token: token,
          platform: PushNotificationService.platform,
        );
        result.fold(
          (_) {
            // On enregistre quand même les préférences, le token pourra être réenregistré plus tard
          },
          (_) => _pushService.storeToken(token),
        );
      }
    } else {
      // Retirer le token du backend
      final storedToken = _pushService.storedToken;
      if (storedToken != null) {
        await _removePushToken(storedToken);
        await _pushService.clearStoredToken();
      }
    }

    final next = state.settings!.copyWith(notificationsEnabled: enabled);
    emit(
      state.copyWith(
        status: SettingsStatus.success,
        settings: next,
        error: null,
      ),
    );
    await _saveSettings(next);
  }

  Future<void> setRemindersEnabled(bool enabled) async {
    if (state.settings == null) return;
    final next = state.settings!.copyWith(remindersEnabled: enabled);
    emit(
      state.copyWith(
        status: SettingsStatus.success,
        settings: next,
        error: null,
      ),
    );
    await _saveSettings(next);
  }
}
