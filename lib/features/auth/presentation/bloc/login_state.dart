part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState._({
    required this.status,
    this.errorMessage,
    this.email,
    this.session,
  });

  const LoginState.initial() : this._(status: LoginStatus.initial);
  const LoginState.loading() : this._(status: LoginStatus.loading);
  const LoginState.success([AuthSession? session])
    : this._(status: LoginStatus.success, session: session);
  const LoginState.failure(String message)
    : this._(status: LoginStatus.failure, errorMessage: message);
  const LoginState.needsEmailVerification(String email)
    : this._(status: LoginStatus.needsEmailVerification, email: email);

  final LoginStatus status;
  final String? errorMessage;
  /// Email à utiliser pour la page de vérification OTP (quand status == needsEmailVerification).
  final String? email;
  /// Session après login réussi (pour mettre à jour AuthBloc immédiatement).
  final AuthSession? session;

  @override
  List<Object?> get props => [status, errorMessage, email, session];
}

enum LoginStatus { initial, loading, success, failure, needsEmailVerification }
