import 'package:equatable/equatable.dart';

class HealthDocument extends Equatable {
  const HealthDocument({
    required this.id,
    required this.title,
    required this.typeLabel,
    required this.dateLabel,
  });

  final String id;
  final String title;
  final String typeLabel;
  final String dateLabel;

  @override
  List<Object?> get props => [id, title, typeLabel, dateLabel];
}

