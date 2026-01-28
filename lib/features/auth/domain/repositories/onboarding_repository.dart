import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, bool>> isCompleted();
  Future<Either<Failure, Unit>> complete();
}
