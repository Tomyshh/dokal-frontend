import 'package:equatable/equatable.dart';

class QuestionnaireField extends Equatable {
  const QuestionnaireField({
    required this.id,
    required this.label,
    required this.isRequired,
    this.maxLines = 2,
    this.translations,
  });

  final String id;

  /// Label in the practitioner's language (source text).
  final String label;
  final bool isRequired;
  final int maxLines;

  /// AI-generated translations keyed by locale code (en, fr, he, ru, am, es).
  final Map<String, String>? translations;

  /// Returns the label in the given locale, falling back to [label].
  String localizedLabel(String locale) {
    return translations?[locale] ?? label;
  }

  @override
  List<Object?> get props => [id, label, isRequired, maxLines, translations];
}
