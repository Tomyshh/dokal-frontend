import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/payment_method.dart';
import '../repositories/account_repository.dart';

class GetPaymentMethods {
  GetPaymentMethods(this.repo);

  final AccountRepository repo;

  Future<Either<Failure, List<PaymentMethod>>> call() =>
      repo.listPaymentMethods();
}

