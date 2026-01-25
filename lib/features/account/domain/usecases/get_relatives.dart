import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/relative.dart';
import '../repositories/account_repository.dart';

class GetRelatives {
  GetRelatives(this.repo);

  final AccountRepository repo;

  Future<Either<Failure, List<Relative>>> call() => repo.listRelatives();
}

