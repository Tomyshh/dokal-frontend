import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_in_with_google.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required SignIn signIn,
    required SignInWithGoogle signInWithGoogle,
  })  : _signIn = signIn,
        _signInWithGoogle = signInWithGoogle,
        super(const LoginState.initial()) {
    on<LoginSubmitted>(_onSubmitted);
    on<LoginWithGoogleRequested>(_onLoginWithGoogleRequested);
  }

  final SignIn _signIn;
  final SignInWithGoogle _signInWithGoogle;

  Future<void> _onLoginWithGoogleRequested(
    LoginWithGoogleRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginState.loading());
    final res = await _signInWithGoogle();
    res.fold(
      (f) => emit(LoginState.failure(f.message)),
      (_) => emit(const LoginState.success()),
    );
  }

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
