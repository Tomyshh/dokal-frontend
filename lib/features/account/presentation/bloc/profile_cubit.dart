import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_profile.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required GetProfile getProfile})
    : _getProfile = getProfile,
      super(const ProfileState.initial());

  final GetProfile _getProfile;

  Future<void> load() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final res = await _getProfile();
    res.fold(
      (f) =>
          emit(state.copyWith(status: ProfileStatus.failure, error: f.message)),
      (profile) => emit(
        state.copyWith(
          status: ProfileStatus.success,
          profile: profile,
          error: null,
        ),
      ),
    );
  }
}
