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
    this.isPast = false,
    this.patientName,
    this.address,
    this.avatarUrl,
  });

  final String id;
  final String practitionerId;
  final String dateLabel;
  final String timeLabel;
  final String practitionerName;
  final String specialty;
  final String reason;
  final bool isPast;
  final String? patientName;
  final String? address;
  final String? avatarUrl;

  @override
  List<Object?> get props => [
    id,
    practitionerId,
    dateLabel,
    timeLabel,
    practitionerName,
    specialty,
    reason,
    isPast,
    patientName,
    address,
    avatarUrl,
  ];
}
