import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/auth_session.dart';

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
      throw const AuthException('Connexion échouée. Réessayez.');
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
      throw const AuthException('Inscription échouée. Réessayez.');
    }
    return AuthSession(userId: user.id, email: user.email);
  }

  @override
  Future<void> signOut() async {
    final client = await _client;
    await client.auth.signOut();
  }
}

