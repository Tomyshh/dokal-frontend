import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/delete_account.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required GetProfile getProfile,
    required DeleteAccount deleteAccount,
    required UpdateProfile updateProfile,
  })  : _getProfile = getProfile,
        _deleteAccount = deleteAccount,
        _updateProfile = updateProfile,
        super(const ProfileState.initial());

  final GetProfile _getProfile;
  final DeleteAccount _deleteAccount;
  final UpdateProfile _updateProfile;

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

  Future<void> updateName({required String firstName, required String lastName}) async {
    if (state.isUpdating) return;
    emit(state.copyWith(isUpdating: true, updateError: null));
    final res = await _updateProfile(firstName: firstName, lastName: lastName);
    res.fold(
      (f) => emit(
        state.copyWith(isUpdating: false, updateError: f.message),
      ),
      (_) async {
        await load();
        if (!isClosed) {
          emit(state.copyWith(isUpdating: false, updateError: null));
        }
      },
    );
  }

  Future<void> deleteAccount() async {
    if (state.deleteAccountStatus == DeleteAccountStatus.loading) return;

    emit(
      state.copyWith(
        deleteAccountStatus: DeleteAccountStatus.loading,
        deleteAccountError: null,
      ),
    );

    final res = await _deleteAccount();
    res.fold(
      (f) => emit(
        state.copyWith(
          deleteAccountStatus: DeleteAccountStatus.failure,
          deleteAccountError: f.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          deleteAccountStatus: DeleteAccountStatus.success,
          deleteAccountError: null,
        ),
      ),
    );
  }
}
