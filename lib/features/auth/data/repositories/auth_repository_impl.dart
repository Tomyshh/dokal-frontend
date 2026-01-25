import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.remote});

  final AuthRemoteDataSource remote;

  @override
  Future<Either<Failure, AuthSession?>> getSession() async {
    try {
      final session = await remote.getSession();
      return Right(session);
    } catch (e) {
      return Left(Failure(_messageFrom(e)));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final session = await remote.signIn(email: email, password: password);
      return Right(session);
    } catch (e) {
      return Left(Failure(_messageFrom(e)));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final session = await remote.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      return Right(session);
    } catch (e) {
      return Left(Failure(_messageFrom(e)));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await remote.signOut();
      return const Right(unit);
    } catch (e) {
      return Left(Failure(_messageFrom(e)));
    }
  }

  @override
  Future<Either<Failure, Unit>> requestPasswordReset({
    required String email,
  }) async {
    try {
      await remote.requestPasswordReset(email: email);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(_messageFrom(e)));
    }
  }

  @override
  Future<Either<Failure, Unit>> resendSignupConfirmationEmail({
    required String email,
  }) async {
    try {
      await remote.resendSignupConfirmationEmail(email: email);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(_messageFrom(e)));
    }
  }
}

String _messageFrom(Object e) {
  if (e is AuthException) return e.message;
  return 'Une erreur est survenue. Réessayez.';
}

