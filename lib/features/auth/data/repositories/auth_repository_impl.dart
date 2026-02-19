import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api_client.dart';
import '../../../../l10n/l10n_static.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.remote, required this.api});

  final AuthRemoteDataSource remote;
  final ApiClient api;

  @override
  Future<Either<Failure, AuthSession?>> getSession() async {
    try {
      final session = await remote.getSession();
      if (session == null) return const Right(null);
      await _assertPatientRoleOrLogout();
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
      await _assertPatientRoleOrLogout();
      return Right(session);
    } on AuthException catch (e) {
      final msg = e.message.trim().toLowerCase();
      if (msg.contains('not confirmed') || msg.contains('email not confirmed')) {
        return Left(Failure(e.message, code: 'EMAIL_NOT_CONFIRMED'));
      }
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(_messageFrom(e)));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> signInWithGoogle() async {
    try {
      final session = await remote.signInWithGoogle();
      await _assertPatientRoleOrLogout();
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
  Future<Either<Failure, Unit>> verifyPasswordResetOtp({
    required String email,
    required String token,
  }) async {
    try {
      await remote.verifyPasswordResetOtp(email: email, token: token);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(_messageFrom(e)));
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePassword({
    required String newPassword,
  }) async {
    try {
      await remote.updatePassword(newPassword: newPassword);
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

  @override
  Future<Either<Failure, AuthSession>> verifySignupOtp({
    required String email,
    required String token,
  }) async {
    try {
      final session = await remote.verifySignupOtp(email: email, token: token);
      await _assertPatientRoleOrLogout();
      return Right(session);
    } catch (e) {
      return Left(Failure(_messageFrom(e)));
    }
  }

  Future<void> _assertPatientRoleOrLogout() async {
    try {
      final res = await api.get('/api/v1/profile');
      final json = res is Map<String, dynamic> ? res : const <String, dynamic>{};
      final role = (json['role'] as String? ?? 'patient').trim().toLowerCase();
      if (role != 'patient') {
        await remote.signOut();
        throw AuthException(l10nStatic.authOnlyPatientsAllowed);
      }
    } catch (e) {
      // Si on ne peut pas vérifier le profil/role (backend down, 401, etc.),
      // on coupe la session pour éviter un état incohérent.
      try {
        await remote.signOut();
      } catch (_) {}
      rethrow;
    }
  }
}

String _messageFrom(Object e) {
  if (e is AuthException) return e.message;
  if (e is ServerException) return e.message;
  return l10nStatic.errorGenericTryAgain;
}
