import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/auth_session.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSession?>> getSession();

  Future<Either<Failure, AuthSession>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthSession>> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  });

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, Unit>> requestPasswordReset({
    required String email,
  });

  Future<Either<Failure, Unit>> resendSignupConfirmationEmail({
    required String email,
  });
}

