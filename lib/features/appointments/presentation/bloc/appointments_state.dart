part of 'appointments_cubit.dart';

enum AppointmentsStatus { initial, loading, success, failure }

class AppointmentsState extends Equatable {
  const AppointmentsState({
    required this.status,
    required this.upcoming,
    required this.past,
    this.error,
  });

  const AppointmentsState.initial()
    : status = AppointmentsStatus.initial,
      upcoming = const [],
      past = const [],
      error = null;

  final AppointmentsStatus status;
  final List<Appointment> upcoming;
  final List<Appointment> past;
  final String? error;

  AppointmentsState copyWith({
    AppointmentsStatus? status,
    List<Appointment>? upcoming,
    List<Appointment>? past,
    String? error,
  }) {
    return AppointmentsState(
      status: status ?? this.status,
      upcoming: upcoming ?? this.upcoming,
      past: past ?? this.past,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, upcoming, past, error];
}
