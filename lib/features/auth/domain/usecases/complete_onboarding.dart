import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/onboarding_repository.dart';

class CompleteOnboarding {
  CompleteOnboarding(this.repo);

  final OnboardingRepository repo;

  Future<Either<Failure, Unit>> call() => repo.complete();
}
