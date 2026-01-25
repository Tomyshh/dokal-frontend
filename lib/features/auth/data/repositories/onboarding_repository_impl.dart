import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl({required this.local});

  final OnboardingLocalDataSource local;

  @override
  Future<Either<Failure, bool>> isCompleted() async {
    try {
      return Right(local.isCompleted());
    } catch (_) {
      return const Left(Failure("Impossible de lire l'état d'onboarding."));
    }
  }

  @override
  Future<Either<Failure, Unit>> complete() async {
    try {
      await local.setCompleted();
      return const Right(unit);
    } catch (_) {
      return const Left(Failure("Impossible d'enregistrer l'onboarding."));
    }
  }
}

