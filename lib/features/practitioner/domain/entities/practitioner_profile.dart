import 'package:equatable/equatable.dart';

class PractitionerProfile extends Equatable {
  const PractitionerProfile({
    required this.id,
    required this.name,
    required this.specialty,
    required this.address,
    required this.about,
    required this.nextAvailabilities,
  });

  final String id;
  final String name;
  final String specialty;
  final String address;
  final String about;
  final List<String> nextAvailabilities;

  @override
  List<Object?> get props => [id, name, specialty, address, about, nextAvailabilities];
}

