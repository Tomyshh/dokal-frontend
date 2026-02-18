import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../health/domain/entities/health_profile.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_profile.dart';
import '../../../health/domain/usecases/get_health_profile.dart';
import '../../domain/usecases/update_profile.dart';
import '../../../health/domain/usecases/save_health_profile.dart';

part 'profile_completion_state.dart';

class ProfileCompletionCubit extends Cubit<ProfileCompletionState> {
  ProfileCompletionCubit({
    required GetProfile getProfile,
    required GetHealthProfile getHealthProfile,
    required UpdateProfile updateProfile,
    required SaveHealthProfile saveHealthProfile,
    required SharedPreferences prefs,
  }) : _getProfile = getProfile,
       _getHealthProfile = getHealthProfile,
       _updateProfile = updateProfile,
       _saveHealthProfile = saveHealthProfile,
       _prefs = prefs,
       super(const ProfileCompletionState.initial());

  final GetProfile _getProfile;
  final GetHealthProfile _getHealthProfile;
  final UpdateProfile _updateProfile;
  final SaveHealthProfile _saveHealthProfile;
  final SharedPreferences _prefs;

  static const _kInsuranceProvider = 'patient_insurance_provider';

  Future<void> load() async {
    emit(state.copyWith(status: ProfileCompletionStatus.loading, error: null));
    final profRes = await _getProfile();
    final healthRes = await _getHealthProfile();

    if (profRes.isLeft() || healthRes.isLeft()) {
      final msg =
          profRes.fold((l) => l.message, (_) => null) ??
          healthRes.fold((l) => l.message, (_) => null);
      emit(state.copyWith(status: ProfileCompletionStatus.failure, error: msg));
      return;
    }

    final insuranceProvider = _prefs.getString(_kInsuranceProvider);
    final profile = profRes.getOrElse(() => throw StateError('No profile'));
    final healthProfile = healthRes.getOrElse(() => null);
    emit(
      state.copyWith(
        status: ProfileCompletionStatus.ready,
        profile: profile,
        healthProfile: healthProfile,
        insuranceProvider: insuranceProvider,
        error: null,
      ),
    );
  }

  Future<void> saveRequiredInfo({
    required String firstName,
    required String lastName,
    required String phone,
    required String dateOfBirthIso,
    required String teudatZehut,
    required String kupatHolim,
    String? insuranceProvider,
  }) async {
    emit(state.copyWith(status: ProfileCompletionStatus.saving, error: null));

    final updRes = await _updateProfile(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      dateOfBirth: dateOfBirthIso,
    );

    if (updRes.isLeft()) {
      emit(
        state.copyWith(
          status: ProfileCompletionStatus.failure,
          error: updRes.fold((l) => l.message, (_) => null),
        ),
      );
      return;
    }

    final hp = HealthProfile(
      fullName: '',
      teudatZehut: teudatZehut,
      dateOfBirth: dateOfBirthIso,
      sex: 'other',
      kupatHolim: kupatHolim,
      insuranceProvider: (insuranceProvider ?? '').trim(),
      kupatMemberId: '',
      familyDoctorName: '',
      bloodType: '',
      allergies: '',
      medicalConditions: '',
      medications: '',
      emergencyContactName: '',
      emergencyContactPhone: '',
    );

    var healthSaveRes = await _saveHealthProfile(hp);
    if (healthSaveRes.isLeft()) {
      final msg = healthSaveRes.fold((l) => l.message, (_) => null) ?? '';
      final shouldRetryWithoutInsurance =
          (insuranceProvider ?? '').trim().isNotEmpty &&
          msg.toLowerCase().contains('insurance_provider');
      if (shouldRetryWithoutInsurance) {
        final hpRetry = HealthProfile(
          fullName: hp.fullName,
          teudatZehut: hp.teudatZehut,
          dateOfBirth: hp.dateOfBirth,
          sex: hp.sex,
          kupatHolim: hp.kupatHolim,
          insuranceProvider: '',
          kupatMemberId: hp.kupatMemberId,
          familyDoctorName: hp.familyDoctorName,
          bloodType: hp.bloodType,
          allergies: hp.allergies,
          medicalConditions: hp.medicalConditions,
          medications: hp.medications,
          emergencyContactName: hp.emergencyContactName,
          emergencyContactPhone: hp.emergencyContactPhone,
        );
        healthSaveRes = await _saveHealthProfile(hpRetry);
      }
    }

    if (healthSaveRes.isLeft()) {
      emit(
        state.copyWith(
          status: ProfileCompletionStatus.failure,
          error: healthSaveRes.fold((l) => l.message, (_) => null),
        ),
      );
      return;
    }

    if (insuranceProvider == null || insuranceProvider.trim().isEmpty) {
      await _prefs.remove(_kInsuranceProvider);
    } else {
      await _prefs.setString(_kInsuranceProvider, insuranceProvider.trim());
    }

    emit(state.copyWith(status: ProfileCompletionStatus.success, error: null));
  }

  void clearSuccess() {
    if (state.status == ProfileCompletionStatus.success) {
      emit(state.copyWith(status: ProfileCompletionStatus.ready));
    }
  }
}
