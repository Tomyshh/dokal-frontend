import '../../../../core/network/api_client.dart';
import '../../domain/entities/health_profile.dart';
import 'health_profile_local_data_source.dart';

/// Remote implementation of [HealthProfileLocalDataSource] backed by the Dokal
/// backend REST API.
class HealthProfileRemoteDataSourceImpl
    implements HealthProfileLocalDataSource {
  HealthProfileRemoteDataSourceImpl({required this.api});

  final ApiClient api;

  @override
  HealthProfile? getProfile() =>
      throw UnimplementedError('Use getProfileAsync');

  @override
  Future<void> saveProfile(HealthProfile profile) =>
      throw UnimplementedError('Use saveProfileAsync');

  Future<HealthProfile?> getProfileAsync() async {
    final raw = await api.get('/api/v1/health/profile');
    if (raw == null) return null;
    final json = raw as Map<String, dynamic>;
    if (json.isEmpty) return null;
    return HealthProfile(
      fullName: '', // fullName comes from profiles, not health_profiles
      teudatZehut: json['teudat_zehut'] as String? ?? '',
      dateOfBirth: json['date_of_birth'] as String? ?? '',
      sex: json['sex'] as String? ?? 'other',
      kupatHolim: json['kupat_holim'] as String? ?? '',
      insuranceProvider: json['insurance_provider'] as String? ?? '',
      kupatMemberId: json['kupat_member_id'] as String? ?? '',
      familyDoctorName: json['family_doctor_name'] as String? ?? '',
      bloodType: json['blood_type'] as String? ?? '',
      allergies: '', // separate table
      medicalConditions: '', // separate table
      medications: '', // separate table
      emergencyContactName: json['emergency_contact_name'] as String? ?? '',
      emergencyContactPhone: json['emergency_contact_phone'] as String? ?? '',
    );
  }

  Future<void> saveProfileAsync(HealthProfile profile) async {
    await api.put(
      '/api/v1/health/profile',
      data: {
        'teudat_zehut': profile.teudatZehut,
        'date_of_birth': profile.dateOfBirth,
        'sex': profile.sex,
        'blood_type': profile.bloodType,
        'kupat_holim': profile.kupatHolim,
        if (profile.insuranceProvider.trim().isNotEmpty)
          'insurance_provider': profile.insuranceProvider.trim(),
        'kupat_member_id': profile.kupatMemberId,
        'family_doctor_name': profile.familyDoctorName,
        'emergency_contact_name': profile.emergencyContactName,
        'emergency_contact_phone': profile.emergencyContactPhone,
      },
    );
  }
}
