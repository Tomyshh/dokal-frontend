import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class VerifySignupOtp {
  const VerifySignupOtp(this._repo);
  final AuthRepository _repo;

  Future<Either<Failure, AuthSession>> call({
    required String email,
    required String token,
  }) =>
      _repo.verifySignupOtp(email: email, token: token);
}
