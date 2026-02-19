import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/account_repository.dart';

class DeleteAccount {
  DeleteAccount(this.repo);

  final AccountRepository repo;

  Future<Either<Failure, Unit>> call() => repo.deleteAccount();
}

