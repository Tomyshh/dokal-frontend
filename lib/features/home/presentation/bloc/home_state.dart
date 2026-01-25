part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    required this.status,
    required this.greetingName,
    required this.historyEnabled,
    this.error,
  });

  const HomeState.initial()
      : status = HomeStatus.initial,
        greetingName = 'Tom',
        historyEnabled = false,
        error = null;

  final HomeStatus status;
  final String greetingName;
  final bool historyEnabled;
  final String? error;

  HomeState copyWith({
    HomeStatus? status,
    String? greetingName,
    bool? historyEnabled,
    String? error,
  }) {
    return HomeState(
      status: status ?? this.status,
      greetingName: greetingName ?? this.greetingName,
      historyEnabled: historyEnabled ?? this.historyEnabled,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, greetingName, historyEnabled, error];
}

