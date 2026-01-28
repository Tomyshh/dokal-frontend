import 'dart:convert';

import 'package:equatable/equatable.dart';

class HealthProfile extends Equatable {
  const HealthProfile({
    required this.fullName,
    required this.teudatZehut,
    required this.dateOfBirth,
    required this.sex,
    required this.kupatHolim,
    required this.kupatMemberId,
    required this.familyDoctorName,
    required this.bloodType,
    required this.allergies,
    required this.medicalConditions,
    required this.medications,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
  });

  final String fullName;
  final String teudatZehut;
  final String dateOfBirth; // simple string for now (backend will normalize)
  final String sex; // "male" | "female" | "other"

  /// Israeli HMO: Clalit / Maccabi / Meuhedet / Leumit (or "other")
  final String kupatHolim;
  final String kupatMemberId;

  final String familyDoctorName;

  final String bloodType;
  final String allergies;
  final String medicalConditions;
  final String medications;

  final String emergencyContactName;
  final String emergencyContactPhone;

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'teudatZehut': teudatZehut,
    'dateOfBirth': dateOfBirth,
    'sex': sex,
    'kupatHolim': kupatHolim,
    'kupatMemberId': kupatMemberId,
    'familyDoctorName': familyDoctorName,
    'bloodType': bloodType,
    'allergies': allergies,
    'medicalConditions': medicalConditions,
    'medications': medications,
    'emergencyContactName': emergencyContactName,
    'emergencyContactPhone': emergencyContactPhone,
  };

  static HealthProfile fromJson(Map<String, dynamic> json) {
    return HealthProfile(
      fullName: (json['fullName'] as String?) ?? '',
      teudatZehut: (json['teudatZehut'] as String?) ?? '',
      dateOfBirth: (json['dateOfBirth'] as String?) ?? '',
      sex: (json['sex'] as String?) ?? 'other',
      kupatHolim: (json['kupatHolim'] as String?) ?? 'other',
      kupatMemberId: (json['kupatMemberId'] as String?) ?? '',
      familyDoctorName: (json['familyDoctorName'] as String?) ?? '',
      bloodType: (json['bloodType'] as String?) ?? '',
      allergies: (json['allergies'] as String?) ?? '',
      medicalConditions: (json['medicalConditions'] as String?) ?? '',
      medications: (json['medications'] as String?) ?? '',
      emergencyContactName: (json['emergencyContactName'] as String?) ?? '',
      emergencyContactPhone: (json['emergencyContactPhone'] as String?) ?? '',
    );
  }

  String toJsonString() => jsonEncode(toJson());

  static HealthProfile fromJsonString(String raw) =>
      fromJson(jsonDecode(raw) as Map<String, dynamic>);

  @override
  List<Object?> get props => [
    fullName,
    teudatZehut,
    dateOfBirth,
    sex,
    kupatHolim,
    kupatMemberId,
    familyDoctorName,
    bloodType,
    allergies,
    medicalConditions,
    medications,
    emergencyContactName,
    emergencyContactPhone,
  ];
}
