import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingCompleted {
  GetOnboardingCompleted(this.repo);

  final OnboardingRepository repo;

  Future<Either<Failure, bool>> call() => repo.isCompleted();
}
