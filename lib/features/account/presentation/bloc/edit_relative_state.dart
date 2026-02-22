part of 'edit_relative_cubit.dart';

enum EditRelativeStatus {
  initial,
  loading,
  updateSuccess,
  deleteSuccess,
  failure,
}

class EditRelativeState extends Equatable {
  const EditRelativeState({
    this.status = EditRelativeStatus.initial,
    this.error,
  });

  const EditRelativeState.initial()
      : status = EditRelativeStatus.initial,
        error = null;

  final EditRelativeStatus status;
  final String? error;

  EditRelativeState copyWith({
    EditRelativeStatus? status,
    String? error,
  }) {
    return EditRelativeState(
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, error];
}
