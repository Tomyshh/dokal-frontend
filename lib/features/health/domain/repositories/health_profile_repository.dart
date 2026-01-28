import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/health_profile.dart';

abstract class HealthProfileRepository {
  Future<Either<Failure, HealthProfile?>> getProfile();
  Future<Either<Failure, Unit>> saveProfile(HealthProfile profile);
}
