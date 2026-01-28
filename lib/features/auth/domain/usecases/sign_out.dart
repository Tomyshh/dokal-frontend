import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

class SignOut {
  const SignOut(this._repo);
  final AuthRepository _repo;

  Future<Either<Failure, Unit>> call() => _repo.signOut();
}
