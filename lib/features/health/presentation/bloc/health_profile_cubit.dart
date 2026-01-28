import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/health_profile.dart';
import '../../domain/usecases/get_health_profile.dart';
import '../../domain/usecases/save_health_profile.dart';

part 'health_profile_state.dart';

class HealthProfileCubit extends Cubit<HealthProfileState> {
  HealthProfileCubit({
    required GetHealthProfile getHealthProfile,
    required SaveHealthProfile saveHealthProfile,
  }) : _getHealthProfile = getHealthProfile,
       _saveHealthProfile = saveHealthProfile,
       super(const HealthProfileState.initial());

  final GetHealthProfile _getHealthProfile;
  final SaveHealthProfile _saveHealthProfile;

  Future<void> load() async {
    emit(state.copyWith(status: HealthProfileStatus.loading));
    final res = await _getHealthProfile();
    res.fold(
      (f) => emit(
        state.copyWith(status: HealthProfileStatus.failure, error: f.message),
      ),
      (profile) => emit(
        state.copyWith(
          status: HealthProfileStatus.success,
          profile: profile,
          error: null,
          justSaved: false,
        ),
      ),
    );
  }

  Future<void> save(HealthProfile profile) async {
    emit(state.copyWith(status: HealthProfileStatus.loading, justSaved: false));
    final res = await _saveHealthProfile(profile);
    res.fold(
      (f) => emit(
        state.copyWith(status: HealthProfileStatus.failure, error: f.message),
      ),
      (_) => emit(
        state.copyWith(
          status: HealthProfileStatus.success,
          profile: profile,
          error: null,
          justSaved: true,
        ),
      ),
    );
  }

  void clearJustSavedFlag() {
    if (state.justSaved) emit(state.copyWith(justSaved: false));
  }
}
