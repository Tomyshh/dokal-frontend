import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

class UpdatePassword {
  const UpdatePassword(this._repo);
  final AuthRepository _repo;

  Future<Either<Failure, Unit>> call({required String newPassword}) =>
      _repo.updatePassword(newPassword: newPassword);
}

