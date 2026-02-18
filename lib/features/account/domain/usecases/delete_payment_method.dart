import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/account_repository.dart';

class DeletePaymentMethod {
  DeletePaymentMethod(this.repo);

  final AccountRepository repo;

  Future<Either<Failure, Unit>> call(String id) => repo.deletePaymentMethod(id);
}
