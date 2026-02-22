import 'package:equatable/equatable.dart';

class Relative extends Equatable {
  const Relative({
    required this.id,
    required this.name,
    required this.label,
    this.firstName,
    this.lastName,
    this.relation,
    this.dateOfBirth,
    this.teudatZehut,
    this.kupatHolim,
    this.insuranceProvider,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String label;
  final String? firstName;
  final String? lastName;
  final String? relation;
  final String? dateOfBirth;
  final String? teudatZehut;
  final String? kupatHolim;
  final String? insuranceProvider;
  final String? avatarUrl;

  @override
  List<Object?> get props =>
      [id, name, label, firstName, lastName, relation, dateOfBirth, avatarUrl];
}
