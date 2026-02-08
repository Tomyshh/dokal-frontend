import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  const Appointment({
    required this.id,
    required this.practitionerId,
    required this.dateLabel,
    required this.timeLabel,
    required this.practitionerName,
    required this.specialty,
    required this.reason,
    this.status = 'pending',
    this.isPast = false,
    this.patientName,
    this.address,
    this.avatarUrl,
    this.cancellationReason,
    this.practitionerNotes,
    this.confirmedAt,
    this.cancelledAt,
    this.completedAt,
  });

  final String id;
  final String practitionerId;
  final String dateLabel;
  final String timeLabel;
  final String practitionerName;
  final String specialty;
  final String reason;
  final String status;
  final bool isPast;
  final String? patientName;
  final String? address;
  final String? avatarUrl;
  final String? cancellationReason;
  final String? practitionerNotes;
  final String? confirmedAt;
  final String? cancelledAt;
  final String? completedAt;

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isCancelled =>
      status == 'cancelled_by_patient' || status == 'cancelled_by_practitioner';
  bool get isCompleted => status == 'completed';
  bool get isNoShow => status == 'no_show';

  @override
  List<Object?> get props => [
    id,
    practitionerId,
    dateLabel,
    timeLabel,
    practitionerName,
    specialty,
    reason,
    status,
    isPast,
    patientName,
    address,
    avatarUrl,
    cancellationReason,
    practitionerNotes,
    confirmedAt,
    cancelledAt,
    completedAt,
  ];
}
