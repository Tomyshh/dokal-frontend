part of 'health_list_cubit.dart';

enum HealthListStatus { initial, loading, success, failure }

class HealthListState extends Equatable {
  const HealthListState({
    required this.status,
    required this.items,
    this.error,
  });

  const HealthListState.initial()
      : status = HealthListStatus.initial,
        items = const [],
        error = null;

  final HealthListStatus status;
  final List<HealthItem> items;
  final String? error;

  HealthListState copyWith({
    HealthListStatus? status,
    List<HealthItem>? items,
    String? error,
  }) {
    return HealthListState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, items, error];
}

