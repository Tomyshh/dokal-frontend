import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/request_password_reset.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({required RequestPasswordReset requestPasswordReset})
    : _requestPasswordReset = requestPasswordReset,
      super(const ForgotPasswordState.initial());

  final RequestPasswordReset _requestPasswordReset;

  Future<void> submit({required String email}) async {
    emit(const ForgotPasswordState.loading());
    final res = await _requestPasswordReset(email: email);
    res.fold(
      (f) => emit(ForgotPasswordState.failure(f.message)),
      (_) => emit(const ForgotPasswordState.success()),
    );
  }
}
