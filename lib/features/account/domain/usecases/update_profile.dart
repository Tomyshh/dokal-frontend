import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/account_repository.dart';

class UpdateProfile {
  UpdateProfile(this.repo);

  final AccountRepository repo;

  Future<Either<Failure, Unit>> call({
    String? firstName,
    String? lastName,
    String? phone,
    String? city,
    String? dateOfBirth,
    String? sex,
  }) => repo.updateProfile(
    firstName: firstName,
    lastName: lastName,
    phone: phone,
    city: city,
    dateOfBirth: dateOfBirth,
    sex: sex,
  );
}
