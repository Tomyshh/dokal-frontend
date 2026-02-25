import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/auth_session.dart';
import '../../../../l10n/l10n_static.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSession?> getSession();
  Future<AuthSession> signIn({required String email, required String password});
  /// Connexion avec Google (OAuth ID token). Nécessite que le provider Google soit configuré dans Supabase.
  Future<AuthSession> signInWithGoogle();
  /// Connexion avec Apple (OAuth ID token). Nécessite que le provider Apple soit configuré dans Supabase.
  Future<AuthSession> signInWithApple();
  Future<AuthSession> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  });
  Future<void> signOut();
  Future<void> requestPasswordReset({required String email});
  Future<void> resendSignupConfirmationEmail({required String email});

  /// Vérifie le code OTP à 6 chiffres envoyé par email après signup (config Supabase OTP).
  Future<AuthSession> verifySignupOtp({
    required String email,
    required String token,
  });

  /// Vérifie le code OTP à 6 chiffres envoyé par email pour récupérer le compte (reset mot de passe).
  /// Après succès, Supabase crée une session temporaire utilisée pour `updatePassword`.
  Future<void> verifyPasswordResetOtp({
    required String email,
    required String token,
  });

  /// Met à jour le mot de passe de l'utilisateur courant (session requise).
  Future<void> updatePassword({required String newPassword});
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
      throw AuthException(l10nStatic.authGoogleSignInNotConfigured);
    }
    // Sur iOS, le SDK natif peut crasher si aucun clientId iOS n'est fourni
    // (et/ou si la config iOS n'est pas présente). On échoue proprement.
    if (defaultTargetPlatform == TargetPlatform.iOS &&
        (googleIosClientId == null || googleIosClientId!.trim().isEmpty)) {
      throw AuthException(l10nStatic.authGoogleSignInUnavailableIos);
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
      throw AuthException(l10nStatic.authGoogleSignInCancelled);
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
  Future<AuthSession> signInWithApple() async {
    final client = await _client;
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final idToken = credential.identityToken;
      if (idToken == null || idToken.isEmpty) {
        throw AuthException(l10nStatic.authSignInFailedTryAgain);
      }
      final res = await client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        accessToken: credential.authorizationCode,
      );
      final user = res.user;
      if (user == null) {
        throw AuthException(l10nStatic.authSignInFailedTryAgain);
      }
      return AuthSession(userId: user.id, email: user.email);
    } on SignInWithAppleAuthorizationException catch (e) {
      // Annulation utilisateur ou erreurs Apple → message propre (pas de crash).
      if (e.code == AuthorizationErrorCode.canceled) {
        throw AuthException(l10nStatic.authAppleSignInCancelled);
      }
      throw AuthException(l10nStatic.authSignInFailedTryAgain);
    } catch (e) {
      rethrow;
    }
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

  @override
  Future<AuthSession> verifySignupOtp({
    required String email,
    required String token,
  }) async {
    final client = await _client;
    final res = await client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.signup,
    );
    final user = res.user;
    if (user == null) {
      throw AuthException(l10nStatic.authSignInFailedTryAgain);
    }
    return AuthSession(userId: user.id, email: user.email);
  }

  @override
  Future<void> verifyPasswordResetOtp({
    required String email,
    required String token,
  }) async {
    final client = await _client;
    final res = await client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.recovery,
    );
    final user = res.user;
    if (user == null) {
      throw AuthException(l10nStatic.authSignInFailedTryAgain);
    }
  }

  @override
  Future<void> updatePassword({required String newPassword}) async {
    final client = await _client;
    final res = await client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
    if (res.user == null) {
      throw AuthException(l10nStatic.authSignInFailedTryAgain);
    }
  }
}
