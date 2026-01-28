import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/complete_onboarding.dart';
import '../../domain/usecases/get_onboarding_completed.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    required GetOnboardingCompleted getOnboardingCompleted,
    required CompleteOnboarding completeOnboarding,
  }) : _getOnboardingCompleted = getOnboardingCompleted,
       _completeOnboarding = completeOnboarding,
       super(const OnboardingState.initial());

  final GetOnboardingCompleted _getOnboardingCompleted;
  final CompleteOnboarding _completeOnboarding;

  Future<void> load() async {
    emit(state.copyWith(status: OnboardingStatus.loading));
    final res = await _getOnboardingCompleted();
    res.fold(
      (f) => emit(
        state.copyWith(status: OnboardingStatus.failure, error: f.message),
      ),
      (completed) => emit(
        state.copyWith(
          status: OnboardingStatus.success,
          completed: completed,
          error: null,
        ),
      ),
    );
  }

  Future<void> complete() async {
    emit(state.copyWith(status: OnboardingStatus.loading));
    final res = await _completeOnboarding();
    res.fold(
      (f) => emit(
        state.copyWith(status: OnboardingStatus.failure, error: f.message),
      ),
      (_) => emit(
        state.copyWith(
          status: OnboardingStatus.success,
          completed: true,
          error: null,
        ),
      ),
    );
  }
}
