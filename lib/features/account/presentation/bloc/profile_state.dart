part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, failure }

enum DeleteAccountStatus { idle, loading, success, failure }

class ProfileState extends Equatable {
  const ProfileState({
    required this.status,
    required this.profile,
    required this.deleteAccountStatus,
    this.error,
    this.deleteAccountError,
  });

  const ProfileState.initial()
    : status = ProfileStatus.initial,
      profile = null,
      error = null,
      deleteAccountStatus = DeleteAccountStatus.idle,
      deleteAccountError = null;

  final ProfileStatus status;
  final UserProfile? profile;
  final String? error;
  final DeleteAccountStatus deleteAccountStatus;
  final String? deleteAccountError;

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    String? error,
    DeleteAccountStatus? deleteAccountStatus,
    String? deleteAccountError,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      error: error,
      deleteAccountStatus: deleteAccountStatus ?? this.deleteAccountStatus,
      deleteAccountError: deleteAccountError,
    );
  }

  @override
  List<Object?> get props => [
    status,
    profile,
    error,
    deleteAccountStatus,
    deleteAccountError,
  ];
}
