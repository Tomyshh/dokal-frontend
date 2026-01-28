import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/health_item.dart';
import '../repositories/health_repository.dart';

class GetHealthList {
  GetHealthList(this.repo);

  final HealthRepository repo;

  Future<Either<Failure, List<HealthItem>>> call(HealthListType type) =>
      repo.list(type);
}
