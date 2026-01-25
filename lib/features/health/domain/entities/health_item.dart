import 'package:equatable/equatable.dart';

class HealthItem extends Equatable {
  const HealthItem({required this.id, required this.label});

  final String id;
  final String label;

  @override
  List<Object?> get props => [id, label];
}

