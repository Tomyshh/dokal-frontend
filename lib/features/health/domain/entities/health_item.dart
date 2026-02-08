import 'package:equatable/equatable.dart';

class HealthItem extends Equatable {
  const HealthItem({
    required this.id,
    required this.label,
    this.reaction,
    this.severity,
    this.dosage,
    this.frequency,
    this.diagnosedOn,
    this.startedOn,
    this.endedOn,
    this.dose,
    this.vaccinatedOn,
    this.notes,
  });

  final String id;
  final String label;
  final String? reaction;
  final String? severity;
  final String? dosage;
  final String? frequency;
  final String? diagnosedOn;
  final String? startedOn;
  final String? endedOn;
  final String? dose;
  final String? vaccinatedOn;
  final String? notes;

  @override
  List<Object?> get props => [
    id,
    label,
    reaction,
    severity,
    dosage,
    frequency,
    diagnosedOn,
    startedOn,
    endedOn,
    dose,
    vaccinatedOn,
    notes,
  ];
}
