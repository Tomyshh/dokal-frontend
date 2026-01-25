part of 'onboarding_cubit.dart';

enum OnboardingStatus { initial, loading, success, failure }

class OnboardingState extends Equatable {
  const OnboardingState({
    required this.status,
    required this.completed,
    this.error,
  });

  const OnboardingState.initial()
      : status = OnboardingStatus.initial,
        completed = false,
        error = null;

  final OnboardingStatus status;
  final bool completed;
  final String? error;

  OnboardingState copyWith({
    OnboardingStatus? status,
    bool? completed,
    String? error,
  }) {
    return OnboardingState(
      status: status ?? this.status,
      completed: completed ?? this.completed,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, completed, error];
}

