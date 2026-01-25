part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState._({
    required this.status,
    this.session,
  });

  const AuthState.unknown() : this._(status: AuthStatus.unknown);
  const AuthState.unauthenticated() : this._(status: AuthStatus.unauthenticated);
  const AuthState.authenticated(AuthSession session)
      : this._(status: AuthStatus.authenticated, session: session);

  final AuthStatus status;
  final AuthSession? session;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  @override
  List<Object?> get props => [status, session];
}

enum AuthStatus { unknown, unauthenticated, authenticated }

