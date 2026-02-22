import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/l10n_static.dart';
import '../../../auth/domain/usecases/get_session.dart';
import '../../../auth/domain/usecases/request_password_reset.dart';
import '../../../auth/domain/usecases/sign_out.dart';
import '../../../auth/domain/usecases/update_password.dart';
import '../../../auth/domain/usecases/verify_password_reset_otp.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit({
    required GetSession getSession,
    required RequestPasswordReset requestPasswordReset,
    required VerifyPasswordResetOtp verifyPasswordResetOtp,
    required UpdatePassword updatePassword,
    required SignOut signOut,
  })  : _getSession = getSession,
        _requestPasswordReset = requestPasswordReset,
        _verifyPasswordResetOtp = verifyPasswordResetOtp,
        _updatePassword = updatePassword,
        _signOut = signOut,
        super(const ChangePasswordState.initial());

  final GetSession _getSession;
  final RequestPasswordReset _requestPasswordReset;
  final VerifyPasswordResetOtp _verifyPasswordResetOtp;
  final UpdatePassword _updatePassword;
  final SignOut _signOut;

  /// Envoie le code OTP à 6 chiffres par email via Supabase.
  Future<void> sendOtp() async {
    emit(state.copyWith(status: ChangePasswordStatus.loading));
    final sessionRes = await _getSession();
    await sessionRes.fold(
      (f) async => emit(
        state.copyWith(status: ChangePasswordStatus.failure, error: f.message),
      ),
      (session) async {
        final email = session?.email;
        if (email == null || email.isEmpty) {
          emit(state.copyWith(
            status: ChangePasswordStatus.failure,
            error: l10nStatic.errorUnableToRetrieveEmail,
          ));
          return;
        }
        final res = await _requestPasswordReset(email: email);
        res.fold(
          (f) => emit(
            state.copyWith(
              status: ChangePasswordStatus.failure,
              error: f.message,
            ),
          ),
          (_) => emit(
            state.copyWith(
              step: ChangePasswordStep.enterOtp,
              status: ChangePasswordStatus.initial,
              email: email,
              error: null,
            ),
          ),
        );
      },
    );
  }

  /// Vérifie le code OTP saisi par l'utilisateur.
  Future<void> verifyOtp({required String token}) async {
    final email = state.email;
    if (email == null || email.isEmpty) return;
    emit(state.copyWith(status: ChangePasswordStatus.loading));
    final res = await _verifyPasswordResetOtp(email: email, token: token);
    res.fold(
      (f) => emit(
        state.copyWith(status: ChangePasswordStatus.failure, error: f.message),
      ),
      (_) => emit(
        state.copyWith(
          step: ChangePasswordStep.enterNewPassword,
          status: ChangePasswordStatus.initial,
          error: null,
        ),
      ),
    );
  }

  /// Met à jour le mot de passe après vérification OTP réussie.
  Future<void> updatePassword({required String newPassword}) async {
    emit(state.copyWith(status: ChangePasswordStatus.loading));
    final res = await _updatePassword(newPassword: newPassword);
    await res.fold(
      (f) async => emit(
        state.copyWith(status: ChangePasswordStatus.failure, error: f.message),
      ),
      (_) async {
        try {
          await _signOut();
        } catch (_) {}
        emit(state.copyWith(status: ChangePasswordStatus.success, error: null));
      },
    );
  }

  /// Renvoie le code OTP (depuis l'étape enterOtp).
  Future<void> resendOtp() async {
    final email = state.email;
    if (email == null || email.isEmpty) return;
    emit(state.copyWith(status: ChangePasswordStatus.loading));
    final res = await _requestPasswordReset(email: email);
    res.fold(
      (f) => emit(
        state.copyWith(status: ChangePasswordStatus.failure, error: f.message),
      ),
      (_) => emit(state.copyWith(status: ChangePasswordStatus.initial)),
    );
  }
}
