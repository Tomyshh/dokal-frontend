import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../health/domain/entities/health_profile.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/upload_avatar.dart';
import '../../../health/domain/usecases/get_health_profile.dart';
import '../../../health/domain/usecases/save_health_profile.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit({
    required GetProfile getProfile,
    required GetHealthProfile getHealthProfile,
    required UpdateProfile updateProfile,
    required SaveHealthProfile saveHealthProfile,
    required UploadAvatar uploadAvatar,
  })  : _getProfile = getProfile,
        _getHealthProfile = getHealthProfile,
        _updateProfile = updateProfile,
        _saveHealthProfile = saveHealthProfile,
        _uploadAvatar = uploadAvatar,
        super(const EditProfileState.initial());

  final GetProfile _getProfile;
  final GetHealthProfile _getHealthProfile;
  final UpdateProfile _updateProfile;
  final SaveHealthProfile _saveHealthProfile;
  final UploadAvatar _uploadAvatar;

  Future<void> load() async {
    emit(state.copyWith(status: EditProfileStatus.loading, error: null));
    final profileRes = await _getProfile();
    final healthRes = await _getHealthProfile();

    profileRes.fold(
      (f) => emit(
        state.copyWith(
          status: EditProfileStatus.failure,
          error: f.message,
        ),
      ),
      (profile) async {
        healthRes.fold(
          (f) => emit(
            state.copyWith(
              status: EditProfileStatus.failure,
              profile: profile,
              error: f.message,
            ),
          ),
          (health) => emit(
            state.copyWith(
              status: EditProfileStatus.success,
              profile: profile,
              healthProfile: health,
              error: null,
            ),
          ),
        );
      },
    );
  }

  Future<void> save({
    required String firstName,
    required String lastName,
    required String teudatZehut,
    required String dateOfBirth,
    required String kupatHolim,
    String? insuranceProvider,
    String? avatarFilePath,
  }) async {
    emit(state.copyWith(status: EditProfileStatus.loading, error: null));

    if (avatarFilePath != null && avatarFilePath.trim().isNotEmpty) {
      final uploadRes = await _uploadAvatar(avatarFilePath.trim());
      uploadRes.fold(
        (f) => emit(
          state.copyWith(
            status: EditProfileStatus.failure,
            error: f.message,
          ),
        ),
        (_) {},
      );
      if (state.status == EditProfileStatus.failure) return;
    }

    final isoDate = _toIsoDate(dateOfBirth);
    final profileRes = await _updateProfile(
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: isoDate,
    );

    await profileRes.fold(
      (f) async => emit(
        state.copyWith(
          status: EditProfileStatus.failure,
          error: f.message,
        ),
      ),
      (_) async {
        final hp = HealthProfile(
          fullName: '$firstName $lastName',
          teudatZehut: teudatZehut,
          dateOfBirth: isoDate ?? '',
          sex: state.healthProfile?.sex ?? 'other',
          kupatHolim: kupatHolim.isEmpty ? 'other' : kupatHolim,
          insuranceProvider: insuranceProvider ?? '',
          kupatMemberId: state.healthProfile?.kupatMemberId ?? '',
          familyDoctorName: state.healthProfile?.familyDoctorName ?? '',
          bloodType: state.healthProfile?.bloodType ?? '',
          allergies: state.healthProfile?.allergies ?? '',
          medicalConditions: state.healthProfile?.medicalConditions ?? '',
          medications: state.healthProfile?.medications ?? '',
          emergencyContactName:
              state.healthProfile?.emergencyContactName ?? '',
          emergencyContactPhone:
              state.healthProfile?.emergencyContactPhone ?? '',
        );
        final healthRes = await _saveHealthProfile(hp);
        healthRes.fold(
          (f) => emit(
            state.copyWith(
              status: EditProfileStatus.failure,
              error: f.message,
            ),
          ),
          (_) => emit(state.copyWith(status: EditProfileStatus.saveSuccess)),
        );
      },
    );
  }

  String? _toIsoDate(String date) {
    final parts = date.split('/');
    if (parts.length != 3) return date;
    final day = parts[0].padLeft(2, '0');
    final month = parts[1].padLeft(2, '0');
    final year = parts[2];
    if (day.length != 2 || month.length != 2 || year.length != 4) return date;
    return '$year-$month-$day';
  }
}
