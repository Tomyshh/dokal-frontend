import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  const AuthSession({
    required this.userId,
    required this.email,
    this.isNewUser = false,
  });

  final String userId;
  final String? email;

  /// `true` si le compte vient d'être créé par un OAuth sign-in (Google/Apple).
  final bool isNewUser;

  @override
  List<Object?> get props => [userId, email, isNewUser];
}
