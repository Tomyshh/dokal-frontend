part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Mode du flux OAuth : login (connexion) ou register (inscription).
enum OAuthMode { login, register }

class LoginWithGoogleRequested extends LoginEvent {
  const LoginWithGoogleRequested({this.mode = OAuthMode.login});

  final OAuthMode mode;

  @override
  List<Object?> get props => [mode];
}

class LoginWithAppleRequested extends LoginEvent {
  const LoginWithAppleRequested({this.mode = OAuthMode.login});

  final OAuthMode mode;

  @override
  List<Object?> get props => [mode];
}
