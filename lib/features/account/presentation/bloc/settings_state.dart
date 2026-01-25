part of 'settings_cubit.dart';

enum SettingsStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  const SettingsState({
    required this.status,
    required this.settings,
    this.error,
  });

  const SettingsState.initial()
      : status = SettingsStatus.initial,
        settings = null,
        error = null;

  final SettingsStatus status;
  final AppSettings? settings;
  final String? error;

  SettingsState copyWith({
    SettingsStatus? status,
    AppSettings? settings,
    String? error,
  }) {
    return SettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, settings, error];
}

