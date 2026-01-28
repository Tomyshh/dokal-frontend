import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/sign_up.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required SignUp signUp})
    : _signUp = signUp,
      super(const RegisterState.initial()) {
    on<RegisterSubmitted>(_onSubmitted);
  }

  final SignUp _signUp;

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterState.loading());
    final res = await _signUp(
      email: event.email,
      password: event.password,
      firstName: event.firstName,
      lastName: event.lastName,
    );
    res.fold(
      (f) => emit(RegisterState.failure(f.message)),
      (_) => emit(const RegisterState.success()),
    );
  }
}
