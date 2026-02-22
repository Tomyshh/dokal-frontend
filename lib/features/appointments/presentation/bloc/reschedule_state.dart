import 'package:equatable/equatable.dart';

import '../../domain/entities/appointment.dart';

enum RescheduleStatus { initial, loading, success, failure }

class RescheduleState extends Equatable {
  const RescheduleState({
    required this.appointmentId,
    required this.practitionerId,
    required this.practitionerName,
    required this.currentDateLabel,
    required this.currentTimeLabel,
    this.selectedDate,
    this.selectedTime,
    this.selectedEndTime,
    this.status = RescheduleStatus.initial,
    this.error,
    this.updatedAppointment,
  });

  final String appointmentId;
  final String practitionerId;
  final String practitionerName;
  final String currentDateLabel;
  final String currentTimeLabel;
  final DateTime? selectedDate;
  final String? selectedTime;
  final String? selectedEndTime;
  final RescheduleStatus status;
  final String? error;
  final Appointment? updatedAppointment;

  bool get canConfirm =>
      selectedDate != null && selectedTime != null && selectedEndTime != null;

  RescheduleState copyWith({
    String? appointmentId,
    String? practitionerId,
    String? practitionerName,
    String? currentDateLabel,
    String? currentTimeLabel,
    DateTime? selectedDate,
    String? selectedTime,
    String? selectedEndTime,
    RescheduleStatus? status,
    String? error,
    Appointment? updatedAppointment,
  }) {
    return RescheduleState(
      appointmentId: appointmentId ?? this.appointmentId,
      practitionerId: practitionerId ?? this.practitionerId,
      practitionerName: practitionerName ?? this.practitionerName,
      currentDateLabel: currentDateLabel ?? this.currentDateLabel,
      currentTimeLabel: currentTimeLabel ?? this.currentTimeLabel,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedEndTime: selectedEndTime ?? this.selectedEndTime,
      status: status ?? this.status,
      error: error,
      updatedAppointment: updatedAppointment ?? this.updatedAppointment,
    );
  }

  @override
  List<Object?> get props => [
        appointmentId,
        practitionerId,
        practitionerName,
        currentDateLabel,
        currentTimeLabel,
        selectedDate,
        selectedTime,
        selectedEndTime,
        status,
        error,
        updatedAppointment,
      ];
}
