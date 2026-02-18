import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.city,
    required this.role,
    this.firstName,
    this.lastName,
    this.phone,
    this.dateOfBirth,
    this.sex,
    this.avatarUrl,
  });

  final String id;
  final String fullName;
  final String email;
  final String city;
  final String role; // "patient" | "practitioner" | "admin"
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? dateOfBirth;
  final String? sex;
  final String? avatarUrl;

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    city,
    role,
    firstName,
    lastName,
    phone,
    dateOfBirth,
    sex,
    avatarUrl,
  ];
}
