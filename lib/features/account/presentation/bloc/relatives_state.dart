part of 'relatives_cubit.dart';

enum RelativesStatus { initial, loading, success, failure }

class RelativesState extends Equatable {
  const RelativesState({
    required this.status,
    required this.items,
    this.profile,
    this.error,
  });

  const RelativesState.initial()
    : status = RelativesStatus.initial,
      items = const [],
      profile = null,
      error = null;

  final RelativesStatus status;
  final List<Relative> items;
  final UserProfile? profile;
  final String? error;

  RelativesState copyWith({
    RelativesStatus? status,
    List<Relative>? items,
    UserProfile? profile,
    String? error,
  }) {
    return RelativesState(
      status: status ?? this.status,
      items: items ?? this.items,
      profile: profile ?? this.profile,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, items, profile, error];
}
