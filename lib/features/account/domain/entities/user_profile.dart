import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.fullName,
    required this.email,
    required this.city,
  });

  final String fullName;
  final String email;
  final String city;

  @override
  List<Object?> get props => [fullName, email, city];
}

