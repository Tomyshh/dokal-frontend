part of 'quick_booking_cubit.dart';

enum QuickBookingStep { patient, confirm }

enum QuickBookingStatus { initial, loading, success, failure }

class QuickBookingState extends Equatable {
  const QuickBookingState({
    required this.practitionerId,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    this.relativeId,
    this.patientLabel,
    this.step = QuickBookingStep.patient,
    this.status = QuickBookingStatus.initial,
    this.appointmentId,
    this.error,
  });

  final String practitionerId;
  final String appointmentDate;
  final String startTime;
  final String endTime;
  final String? relativeId;
  final String? patientLabel;
  final QuickBookingStep step;
  final QuickBookingStatus status;
  final String? appointmentId;
  final String? error;

  QuickBookingState copyWith({
    String? relativeId,
    String? patientLabel,
    QuickBookingStep? step,
    QuickBookingStatus? status,
    String? appointmentId,
    String? error,
  }) {
    return QuickBookingState(
      practitionerId: practitionerId,
      appointmentDate: appointmentDate,
      startTime: startTime,
      endTime: endTime,
      relativeId: relativeId ?? this.relativeId,
      patientLabel: patientLabel ?? this.patientLabel,
      step: step ?? this.step,
      status: status ?? this.status,
      appointmentId: appointmentId ?? this.appointmentId,
      error: (status ?? this.status) == QuickBookingStatus.success
          ? null
          : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
        practitionerId,
        appointmentDate,
        startTime,
        endTime,
        relativeId,
        patientLabel,
        step,
        status,
        appointmentId,
        error,
      ];
}
