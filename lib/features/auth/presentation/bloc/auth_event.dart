part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthRefreshRequested extends AuthEvent {
  const AuthRefreshRequested();
}

/// Met à jour l'état avec une session déjà validée (ex. juste après signIn).
/// Évite d'attendre GetSession et garantit que le routeur voit tout de suite isAuthenticated.
class AuthSessionRestored extends AuthEvent {
  const AuthSessionRestored(this.session);
  final AuthSession session;

  @override
  List<Object?> get props => [session];
}
