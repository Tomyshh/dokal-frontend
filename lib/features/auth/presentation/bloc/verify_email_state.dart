import 'package:equatable/equatable.dart';

enum VerifyEmailStatus { initial, loading, success, failure }

class VerifyEmailState extends Equatable {
  const VerifyEmailState._({required this.status, this.errorMessage});

  const VerifyEmailState.initial() : this._(status: VerifyEmailStatus.initial);
  const VerifyEmailState.loading() : this._(status: VerifyEmailStatus.loading);
  const VerifyEmailState.success() : this._(status: VerifyEmailStatus.success);
  const VerifyEmailState.failure(String message)
    : this._(status: VerifyEmailStatus.failure, errorMessage: message);

  final VerifyEmailStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];
}
