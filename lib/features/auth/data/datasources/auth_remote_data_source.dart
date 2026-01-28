import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/auth_session.dart';
import '../../../../l10n/l10n_static.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSession?> getSession();
  Future<AuthSession> signIn({required String email, required String password});
  Future<AuthSession> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  });
  Future<void> signOut();
  Future<void> requestPasswordReset({required String email});
  Future<void> resendSignupConfirmationEmail({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required this.supabaseClientFuture});

  final Future<SupabaseClient> supabaseClientFuture;

  Future<SupabaseClient> get _client => supabaseClientFuture;

  @override
  Future<AuthSession?> getSession() async {
    final client = await _client;
    final session = client.auth.currentSession;
    final user = session?.user;
    if (user == null) return null;
    return AuthSession(userId: user.id, email: user.email);
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final client = await _client;
    final res = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = res.user;
    if (user == null) {
      throw AuthException(l10nStatic.authSignInFailedTryAgain);
    }
    return AuthSession(userId: user.id, email: user.email);
  }

  @override
  Future<AuthSession> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    final client = await _client;
    final res = await client.auth.signUp(
      email: email,
      password: password,
      data: {
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
      },
    );
    final user = res.user;
    if (user == null) {
      throw AuthException(l10nStatic.authSignUpFailedTryAgain);
    }
    return AuthSession(userId: user.id, email: user.email);
  }

  @override
  Future<void> signOut() async {
    final client = await _client;
    await client.auth.signOut();
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    final client = await _client;
    await client.auth.resetPasswordForEmail(email);
  }

  @override
  Future<void> resendSignupConfirmationEmail({required String email}) async {
    final client = await _client;
    await client.auth.resend(type: OtpType.signup, email: email);
  }
}
