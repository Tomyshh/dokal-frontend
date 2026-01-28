import 'package:equatable/equatable.dart';

enum ForgotPasswordStatus { initial, loading, success, failure }

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState._({required this.status, this.errorMessage});

  const ForgotPasswordState.initial()
    : this._(status: ForgotPasswordStatus.initial);
  const ForgotPasswordState.loading()
    : this._(status: ForgotPasswordStatus.loading);
  const ForgotPasswordState.success()
    : this._(status: ForgotPasswordStatus.success);
  const ForgotPasswordState.failure(String message)
    : this._(status: ForgotPasswordStatus.failure, errorMessage: message);

  final ForgotPasswordStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];
}
