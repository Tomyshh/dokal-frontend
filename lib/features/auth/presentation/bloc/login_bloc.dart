import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/sign_in.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required SignIn signIn})
    : _signIn = signIn,
      super(const LoginState.initial()) {
    on<LoginSubmitted>(_onSubmitted);
  }

  final SignIn _signIn;

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginState.loading());
    final res = await _signIn(email: event.email, password: event.password);
    res.fold(
      (f) => emit(LoginState.failure(f.message)),
      (_) => emit(const LoginState.success()),
    );
  }
}
