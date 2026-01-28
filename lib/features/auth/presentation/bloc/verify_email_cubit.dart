import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/resend_signup_confirmation_email.dart';
import 'verify_email_state.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  VerifyEmailCubit({required ResendSignupConfirmationEmail resend})
    : _resend = resend,
      super(const VerifyEmailState.initial());

  final ResendSignupConfirmationEmail _resend;

  Future<void> resend({required String email}) async {
    emit(const VerifyEmailState.loading());
    final res = await _resend(email: email);
    res.fold(
      (f) => emit(VerifyEmailState.failure(f.message)),
      (_) => emit(const VerifyEmailState.success()),
    );
  }
}
