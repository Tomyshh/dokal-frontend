import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/account_repository.dart';

class DeleteRelative {
  DeleteRelative(this.repo);

  final AccountRepository repo;

  Future<Either<Failure, Unit>> call(String id) => repo.deleteRelative(id);
}
