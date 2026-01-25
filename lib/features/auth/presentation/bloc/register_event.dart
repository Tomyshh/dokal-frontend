part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted({
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
  });

  final String email;
  final String password;
  final String? firstName;
  final String? lastName;

  @override
  List<Object?> get props => [email, password, firstName, lastName];
}

