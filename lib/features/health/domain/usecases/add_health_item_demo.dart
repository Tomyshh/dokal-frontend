import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/health_repository.dart';

class AddHealthItemDemo {
  AddHealthItemDemo(this.repo);

  final HealthRepository repo;

  Future<Either<Failure, Unit>> call(HealthListType type) => repo.addDemo(type);
}
