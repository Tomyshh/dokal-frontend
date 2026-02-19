import 'package:equatable/equatable.dart';

enum VerifyPasswordResetStatus {
  initial,
  loading,
  resendSuccess,
  verifySuccess,
  failure,
}

class VerifyPasswordResetState extends Equatable {
  const VerifyPasswordResetState._({required this.status, this.errorMessage});

  const VerifyPasswordResetState.initial()
    : this._(status: VerifyPasswordResetStatus.initial);
  const VerifyPasswordResetState.loading()
    : this._(status: VerifyPasswordResetStatus.loading);
  const VerifyPasswordResetState.resendSuccess()
    : this._(status: VerifyPasswordResetStatus.resendSuccess);
  const VerifyPasswordResetState.verifySuccess()
    : this._(status: VerifyPasswordResetStatus.verifySuccess);
  const VerifyPasswordResetState.failure(String message)
    : this._(status: VerifyPasswordResetStatus.failure, errorMessage: message);

  final VerifyPasswordResetStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];
}

