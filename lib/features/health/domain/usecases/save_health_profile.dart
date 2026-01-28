import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/health_profile.dart';
import '../repositories/health_profile_repository.dart';

class SaveHealthProfile {
  SaveHealthProfile(this.repo);

  final HealthProfileRepository repo;

  Future<Either<Failure, Unit>> call(HealthProfile profile) =>
      repo.saveProfile(profile);
}
