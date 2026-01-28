import 'package:equatable/equatable.dart';

class PractitionerProfile extends Equatable {
  const PractitionerProfile({
    required this.id,
    required this.name,
    required this.specialty,
    required this.address,
    required this.about,
    required this.nextAvailabilities,
    this.avatarUrl,
    this.sector,
    this.phone,
    this.email,
    this.languages,
    this.education,
    this.yearsOfExperience,
  });

  final String id;
  final String name;
  final String specialty;
  final String address;
  final String about;
  final List<String> nextAvailabilities;
  final String? avatarUrl;
  final String? sector;
  final String? phone;
  final String? email;
  final List<String>? languages;
  final String? education;
  final int? yearsOfExperience;

  @override
  List<Object?> get props => [
    id,
    name,
    specialty,
    address,
    about,
    nextAvailabilities,
    avatarUrl,
    sector,
    phone,
    email,
    languages,
    education,
    yearsOfExperience,
  ];
}
