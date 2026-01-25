import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  const Appointment({
    required this.id,
    required this.dateLabel,
    required this.timeLabel,
    required this.practitionerName,
    required this.specialty,
    required this.reason,
    this.address,
  });

  final String id;
  final String dateLabel;
  final String timeLabel;
  final String practitionerName;
  final String specialty;
  final String reason;
  final String? address;

  @override
  List<Object?> get props => [
        id,
        dateLabel,
        timeLabel,
        practitionerName,
        specialty,
        reason,
        address,
      ];
}

