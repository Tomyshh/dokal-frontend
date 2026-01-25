part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState._({required this.status, this.errorMessage});

  const RegisterState.initial() : this._(status: RegisterStatus.initial);
  const RegisterState.loading() : this._(status: RegisterStatus.loading);
  const RegisterState.success() : this._(status: RegisterStatus.success);
  const RegisterState.failure(String message)
      : this._(status: RegisterStatus.failure, errorMessage: message);

  final RegisterStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];
}

enum RegisterStatus { initial, loading, success, failure }

