import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/health_profile.dart';
import '../repositories/health_profile_repository.dart';

class GetHealthProfile {
  GetHealthProfile(this.repo);

  final HealthProfileRepository repo;

  Future<Either<Failure, HealthProfile?>> call() => repo.getProfile();
}
