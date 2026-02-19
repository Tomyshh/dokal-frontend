import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

class VerifyPasswordResetOtp {
  const VerifyPasswordResetOtp(this._repo);
  final AuthRepository _repo;

  Future<Either<Failure, Unit>> call({
    required String email,
    required String token,
  }) =>
      _repo.verifyPasswordResetOtp(email: email, token: token);
}

