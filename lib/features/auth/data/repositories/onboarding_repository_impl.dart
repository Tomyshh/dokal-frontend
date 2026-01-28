import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../l10n/l10n_static.dart';
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
      return Left(Failure(l10nStatic.errorUnableToReadOnboardingState));
    }
  }

  @override
  Future<Either<Failure, Unit>> complete() async {
    try {
      await local.setCompleted();
      return const Right(unit);
    } catch (_) {
      return Left(Failure(l10nStatic.errorUnableToSaveOnboarding));
    }
  }
}
