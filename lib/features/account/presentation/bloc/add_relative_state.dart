part of 'add_relative_cubit.dart';

enum AddRelativeStatus { initial, loading, success, failure }

class AddRelativeState extends Equatable {
  const AddRelativeState({
    this.status = AddRelativeStatus.initial,
    this.error,
  });

  const AddRelativeState.initial()
      : status = AddRelativeStatus.initial,
        error = null;

  final AddRelativeStatus status;
  final String? error;

  AddRelativeState copyWith({
    AddRelativeStatus? status,
    String? error,
  }) {
    return AddRelativeState(
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, error];
}
