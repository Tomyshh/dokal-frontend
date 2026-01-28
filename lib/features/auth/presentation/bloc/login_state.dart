part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState._({required this.status, this.errorMessage});

  const LoginState.initial() : this._(status: LoginStatus.initial);
  const LoginState.loading() : this._(status: LoginStatus.loading);
  const LoginState.success() : this._(status: LoginStatus.success);
  const LoginState.failure(String message)
    : this._(status: LoginStatus.failure, errorMessage: message);

  final LoginStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];
}

enum LoginStatus { initial, loading, success, failure }
