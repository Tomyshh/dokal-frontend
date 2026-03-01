import 'package:equatable/equatable.dart';

import 'questionnaire_field.dart';

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
    this.instructions = const [],
    this.instructionsTranslations,
    this.questionnaireFields = const [],
    this.questionnaireSubmittedAt,
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

  /// Pre-visit instructions in the practitioner's language.
  final List<String> instructions;

  /// AI-generated translations of instructions keyed by locale (e.g. {"en": [...], "he": [...]}).
  final Map<String, List<String>>? instructionsTranslations;

  /// Dynamic questionnaire fields configured by the practitioner.
  final List<QuestionnaireField> questionnaireFields;

  /// ISO timestamp set by the backend once the patient submits the questionnaire.
  final String? questionnaireSubmittedAt;

  bool get hasInstructions => instructions.isNotEmpty;
  bool get hasQuestionnaire => questionnaireFields.isNotEmpty;
  bool get questionnaireSubmitted => questionnaireSubmittedAt != null;

  /// Returns instructions in the given locale, falling back to source.
  List<String> localizedInstructions(String locale) {
    return instructionsTranslations?[locale] ?? instructions;
  }

  Appointment copyWith({
    String? address,
    List<String>? instructions,
    Map<String, List<String>>? instructionsTranslations,
    List<QuestionnaireField>? questionnaireFields,
    String? questionnaireSubmittedAt,
  }) =>
      Appointment(
        id: id,
        practitionerId: practitionerId,
        dateLabel: dateLabel,
        timeLabel: timeLabel,
        practitionerName: practitionerName,
        specialty: specialty,
        reason: reason,
        status: status,
        isPast: isPast,
        patientName: patientName,
        address: address ?? this.address,
        avatarUrl: avatarUrl,
        cancellationReason: cancellationReason,
        practitionerNotes: practitionerNotes,
        confirmedAt: confirmedAt,
        cancelledAt: cancelledAt,
        completedAt: completedAt,
        instructions: instructions ?? this.instructions,
        instructionsTranslations:
            instructionsTranslations ?? this.instructionsTranslations,
        questionnaireFields: questionnaireFields ?? this.questionnaireFields,
        questionnaireSubmittedAt:
            questionnaireSubmittedAt ?? this.questionnaireSubmittedAt,
      );

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
    instructions,
    instructionsTranslations,
    questionnaireFields,
    questionnaireSubmittedAt,
  ];
}
