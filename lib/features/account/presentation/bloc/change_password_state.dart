part of 'change_password_cubit.dart';

enum ChangePasswordStatus { initial, loading, success, failure }

/// Étapes du flux de changement de mot de passe sécurisé par OTP.
enum ChangePasswordStep {
  /// Envoi du code OTP par email.
  sendOtp,
  /// Saisie du code OTP à 6 chiffres.
  enterOtp,
  /// Saisie du nouveau mot de passe.
  enterNewPassword,
}

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    required this.step,
    required this.status,
    this.email,
    this.error,
  });

  const ChangePasswordState.initial()
    : step = ChangePasswordStep.sendOtp,
      status = ChangePasswordStatus.initial,
      email = null,
      error = null;

  final ChangePasswordStep step;
  final ChangePasswordStatus status;
  final String? email;
  final String? error;

  ChangePasswordState copyWith({
    ChangePasswordStep? step,
    ChangePasswordStatus? status,
    String? email,
    String? error,
  }) {
    return ChangePasswordState(
      step: step ?? this.step,
      status: status ?? this.status,
      email: email ?? this.email,
      error: error,
    );
  }

  @override
  List<Object?> get props => [step, status, email, error];
}
