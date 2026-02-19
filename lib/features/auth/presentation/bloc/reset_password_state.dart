import 'package:equatable/equatable.dart';

enum ResetPasswordStatus { initial, loading, success, failure }

class ResetPasswordState extends Equatable {
  const ResetPasswordState._({required this.status, this.errorMessage});

  const ResetPasswordState.initial() : this._(status: ResetPasswordStatus.initial);
  const ResetPasswordState.loading() : this._(status: ResetPasswordStatus.loading);
  const ResetPasswordState.success() : this._(status: ResetPasswordStatus.success);
  const ResetPasswordState.failure(String message)
    : this._(status: ResetPasswordStatus.failure, errorMessage: message);

  final ResetPasswordStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];
}

