import 'package:equatable/equatable.dart';

class Relative extends Equatable {
  const Relative({
    required this.id,
    required this.name,
    required this.label,
  });

  final String id;
  final String name;
  final String label;

  @override
  List<Object?> get props => [id, name, label];
}

