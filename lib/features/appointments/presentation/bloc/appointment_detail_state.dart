part of 'appointment_detail_cubit.dart';

enum AppointmentDetailStatus { initial, loading, success, failure }

class AppointmentDetailState extends Equatable {
  const AppointmentDetailState({
    required this.status,
    required this.appointmentId,
    required this.appointment,
    this.error,
  });

  const AppointmentDetailState.initial({required this.appointmentId})
      : status = AppointmentDetailStatus.initial,
        appointment = null,
        error = null;

  final AppointmentDetailStatus status;
  final String appointmentId;
  final Appointment? appointment;
  final String? error;

  AppointmentDetailState copyWith({
    AppointmentDetailStatus? status,
    Appointment? appointment,
    String? error,
  }) {
    return AppointmentDetailState(
      status: status ?? this.status,
      appointmentId: appointmentId,
      appointment: appointment,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, appointmentId, appointment, error];
}

