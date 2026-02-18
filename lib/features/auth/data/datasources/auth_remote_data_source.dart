import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/auth_session.dart';
import '../../../../l10n/l10n_static.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSession?> getSession();
  Future<AuthSession> signIn({required String email, required String password});
  /// Connexion avec Google (OAuth ID token). Nécessite que le provider Google soit configuré dans Supabase.
  Future<AuthSession> signInWithGoogle();
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
  AuthRemoteDataSourceImpl({
    required this.supabaseClientFuture,
    required this.googleWebClientId,
    this.googleIosClientId,
  });

  final Future<SupabaseClient> supabaseClientFuture;
  /// Web Client ID (Google Cloud) — requis pour le flux OIDC avec Supabase.
  final String googleWebClientId;
  /// iOS Client ID (optionnel, recommandé sur iOS).
  final String? googleIosClientId;

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
  Future<AuthSession> signInWithGoogle() async {
    if (googleWebClientId.isEmpty) {
      throw const AuthException(
        'Google Sign-In non configuré. Ajoutez GOOGLE_WEB_CLIENT_ID.',
      );
    }
    final client = await _client;
    return _signInWithGoogleLegacy(client);
  }

  /// Ancienne API (google_sign_in) : dialogue centré "Choose an account".
  Future<AuthSession> _signInWithGoogleLegacy(SupabaseClient client) async {
    final googleSignIn = GoogleSignIn(
      serverClientId: googleWebClientId,
      clientId: googleIosClientId,
    );
    // Force l'affichage du sélecteur de compte à chaque tentative.
    // Sinon, GoogleSignIn garde le dernier compte "en mémoire" (et `signIn()`
    // peut réutiliser silencieusement l'ancien compte).
    try {
      await googleSignIn.signOut();
    } catch (_) {}
    final account = await googleSignIn.signIn();
    if (account == null) {
      throw const AuthException('Connexion Google annulée.');
    }
    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw AuthException(l10nStatic.authSignInFailedTryAgain);
    }
    final res = await client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: auth.accessToken,
    );
    final user = res.user;
    if (user == null) {
      throw AuthException(l10nStatic.authSignInFailedTryAgain);
    }
    // Nettoie la session Google côté plugin pour que la prochaine connexion
    // ré-affiche le sélecteur de compte.
    try {
      await googleSignIn.signOut();
    } catch (_) {}
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
