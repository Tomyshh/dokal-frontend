import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/practitioner_profile.dart';
import '../repositories/practitioner_repository.dart';

class GetPractitionerProfile {
  GetPractitionerProfile(this.repo);

  final PractitionerRepository repo;

  Future<Either<Failure, PractitionerProfile>> call(String id) =>
      repo.getById(id);
}
