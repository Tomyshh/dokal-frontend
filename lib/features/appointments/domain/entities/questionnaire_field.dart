import 'package:equatable/equatable.dart';

class QuestionnaireField extends Equatable {
  const QuestionnaireField({
    required this.id,
    required this.label,
    required this.isRequired,
    this.maxLines = 2,
  });

  final String id;
  final String label;
  final bool isRequired;
  final int maxLines;

  @override
  List<Object?> get props => [id, label, isRequired, maxLines];
}
