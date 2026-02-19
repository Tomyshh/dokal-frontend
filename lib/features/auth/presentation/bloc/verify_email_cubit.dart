import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/resend_signup_confirmation_email.dart';
import '../../domain/usecases/verify_signup_otp.dart';
import 'verify_email_state.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  VerifyEmailCubit({
    required ResendSignupConfirmationEmail resend,
    required VerifySignupOtp verifyOtp,
  })  : _resend = resend,
        _verifyOtp = verifyOtp,
        super(const VerifyEmailState.initial());

  final ResendSignupConfirmationEmail _resend;
  final VerifySignupOtp _verifyOtp;

  Future<void> resend({required String email}) async {
    emit(const VerifyEmailState.loading());
    final res = await _resend(email: email);
    res.fold(
      (f) => emit(VerifyEmailState.failure(f.message)),
      (_) => emit(const VerifyEmailState.success()),
    );
  }

  Future<void> verify({required String email, required String token}) async {
    emit(const VerifyEmailState.loading());
    final res = await _verifyOtp(email: email, token: token);
    res.fold(
      (f) => emit(VerifyEmailState.failure(f.message)),
      (_) => emit(const VerifyEmailState.verifySuccess()),
    );
  }
}
