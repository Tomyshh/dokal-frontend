import 'package:equatable/equatable.dart';

class HomePractitioner extends Equatable {
  const HomePractitioner({
    required this.id,
    required this.name,
    required this.specialty,
  });

  final String id;
  final String name;
  final String specialty;

  @override
  List<Object?> get props => [id, name, specialty];
}

