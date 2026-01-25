part of 'change_password_cubit.dart';

enum ChangePasswordStatus { initial, loading, success, failure }

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    required this.status,
    this.error,
  });

  const ChangePasswordState.initial()
      : status = ChangePasswordStatus.initial,
        error = null;

  final ChangePasswordStatus status;
  final String? error;

  ChangePasswordState copyWith({
    ChangePasswordStatus? status,
    String? error,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, error];
}

