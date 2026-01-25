import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/request_password_change_demo.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit({required RequestPasswordChangeDemo requestPasswordChangeDemo})
      : _requestPasswordChangeDemo = requestPasswordChangeDemo,
        super(const ChangePasswordState.initial());

  final RequestPasswordChangeDemo _requestPasswordChangeDemo;

  Future<void> submit() async {
    emit(state.copyWith(status: ChangePasswordStatus.loading));
    final res = await _requestPasswordChangeDemo();
    res.fold(
      (f) => emit(state.copyWith(status: ChangePasswordStatus.failure, error: f.message)),
      (_) => emit(state.copyWith(status: ChangePasswordStatus.success, error: null)),
    );
  }
}

