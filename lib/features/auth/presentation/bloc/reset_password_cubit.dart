import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/update_password.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit({required UpdatePassword updatePassword, required SignOut signOut})
    : _updatePassword = updatePassword,
      _signOut = signOut,
      super(const ResetPasswordState.initial());

  final UpdatePassword _updatePassword;
  final SignOut _signOut;

  Future<void> submit({required String newPassword}) async {
    emit(const ResetPasswordState.loading());
    final res = await _updatePassword(newPassword: newPassword);
    await res.fold(
      (f) async => emit(ResetPasswordState.failure(f.message)),
      (_) async {
        // On termine le flux recovery en coupant la session Supabase,
        // puis l'utilisateur se reconnecte avec le nouveau mot de passe.
        try {
          await _signOut();
        } catch (_) {}
        emit(const ResetPasswordState.success());
      },
    );
  }
}

