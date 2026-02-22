import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/relative.dart';
import '../repositories/account_repository.dart';

class AddRelative {
  AddRelative(this.repo);

  final AccountRepository repo;

  Future<Either<Failure, Relative>> call({
    required String firstName,
    required String lastName,
    required String teudatZehut,
    required String? dateOfBirth,
    required String relation,
    String? kupatHolim,
    String? insuranceProvider,
  }) =>
      repo.addRelative(
        firstName: firstName,
        lastName: lastName,
        teudatZehut: teudatZehut,
        dateOfBirth: dateOfBirth,
        relation: relation,
        kupatHolim: kupatHolim,
        insuranceProvider: insuranceProvider,
      );
}
