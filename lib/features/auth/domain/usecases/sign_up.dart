import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  const SignUp(this._repo);
  final AuthRepository _repo;

  Future<Either<Failure, AuthSession>> call({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) =>
      _repo.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
}

