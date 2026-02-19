import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/request_password_reset.dart';
import '../../domain/usecases/verify_password_reset_otp.dart';
import 'verify_password_reset_state.dart';

class VerifyPasswordResetCubit extends Cubit<VerifyPasswordResetState> {
  VerifyPasswordResetCubit({
    required RequestPasswordReset resendCode,
    required VerifyPasswordResetOtp verifyOtp,
  })  : _resendCode = resendCode,
        _verifyOtp = verifyOtp,
        super(const VerifyPasswordResetState.initial());

  final RequestPasswordReset _resendCode;
  final VerifyPasswordResetOtp _verifyOtp;

  Future<void> resend({required String email}) async {
    emit(const VerifyPasswordResetState.loading());
    final res = await _resendCode(email: email);
    res.fold(
      (f) => emit(VerifyPasswordResetState.failure(f.message)),
      (_) => emit(const VerifyPasswordResetState.resendSuccess()),
    );
  }

  Future<void> verify({required String email, required String token}) async {
    emit(const VerifyPasswordResetState.loading());
    final res = await _verifyOtp(email: email, token: token);
    res.fold(
      (f) => emit(VerifyPasswordResetState.failure(f.message)),
      (_) => emit(const VerifyPasswordResetState.verifySuccess()),
    );
  }
}

