import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/practitioner_profile.dart';

abstract class PractitionerRepository {
  Future<Either<Failure, PractitionerProfile>> getById(String id);
}
