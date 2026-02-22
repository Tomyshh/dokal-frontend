import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/account_repository.dart';

class UpdateRelative {
  UpdateRelative(this.repo);

  final AccountRepository repo;

  Future<Either<Failure, Unit>> call({
    required String id,
    required String firstName,
    required String lastName,
    required String teudatZehut,
    String? dateOfBirth,
    required String relation,
    String? kupatHolim,
    String? insuranceProvider,
    String? avatarUrl,
  }) =>
      repo.updateRelative(
        id: id,
        firstName: firstName,
        lastName: lastName,
        teudatZehut: teudatZehut,
        dateOfBirth: dateOfBirth,
        relation: relation,
        kupatHolim: kupatHolim,
        insuranceProvider: insuranceProvider,
        avatarUrl: avatarUrl,
      );
}
