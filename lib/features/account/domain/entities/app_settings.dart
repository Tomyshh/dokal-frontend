import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  const AppSettings({
    required this.notificationsEnabled,
    required this.remindersEnabled,
  });

  final bool notificationsEnabled;
  final bool remindersEnabled;

  AppSettings copyWith({bool? notificationsEnabled, bool? remindersEnabled}) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
    );
  }

  @override
  List<Object?> get props => [notificationsEnabled, remindersEnabled];
}
