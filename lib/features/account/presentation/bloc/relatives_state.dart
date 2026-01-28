part of 'relatives_cubit.dart';

enum RelativesStatus { initial, loading, success, failure }

class RelativesState extends Equatable {
  const RelativesState({required this.status, required this.items, this.error});

  const RelativesState.initial()
    : status = RelativesStatus.initial,
      items = const [],
      error = null;

  final RelativesStatus status;
  final List<Relative> items;
  final String? error;

  RelativesState copyWith({
    RelativesStatus? status,
    List<Relative>? items,
    String? error,
  }) {
    return RelativesState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, items, error];
}
