import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/permissions/permissions_service.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/save_settings.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required GetSettings getSettings,
    required SaveSettings saveSettings,
    required PermissionsService permissionsService,
  })  : _getSettings = getSettings,
        _saveSettings = saveSettings,
        _permissionsService = permissionsService,
        super(const SettingsState.initial());

  final GetSettings _getSettings;
  final SaveSettings _saveSettings;
  final PermissionsService _permissionsService;

  Future<void> load() async {
    emit(state.copyWith(status: SettingsStatus.loading));
    final res = await _getSettings();
    res.fold(
      (f) => emit(state.copyWith(status: SettingsStatus.failure, error: f.message)),
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

    // Si on active, on demande la permission (Android 13+/iOS).
    if (enabled) {
      final granted = await _permissionsService.requestNotifications();
      if (!granted) {
        emit(state.copyWith(status: SettingsStatus.failure, error: 'Permission notifications refusée.'));
        // Forcer le switch à OFF.
        final reverted = state.settings!.copyWith(notificationsEnabled: false);
        emit(state.copyWith(status: SettingsStatus.success, settings: reverted, error: null));
        await _saveSettings(reverted);
        return;
      }
    }

    final next = state.settings!.copyWith(notificationsEnabled: enabled);
    emit(state.copyWith(status: SettingsStatus.success, settings: next, error: null));
    await _saveSettings(next);
  }

  Future<void> setRemindersEnabled(bool enabled) async {
    if (state.settings == null) return;
    final next = state.settings!.copyWith(remindersEnabled: enabled);
    emit(state.copyWith(status: SettingsStatus.success, settings: next, error: null));
    await _saveSettings(next);
  }
}

