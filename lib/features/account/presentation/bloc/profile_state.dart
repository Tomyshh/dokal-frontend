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
    this.isUpdating = false,
    this.updateError,
  });

  const ProfileState.initial()
    : status = ProfileStatus.initial,
      profile = null,
      error = null,
      deleteAccountStatus = DeleteAccountStatus.idle,
      deleteAccountError = null,
      isUpdating = false,
      updateError = null;

  final ProfileStatus status;
  final UserProfile? profile;
  final String? error;
  final DeleteAccountStatus deleteAccountStatus;
  final String? deleteAccountError;
  final bool isUpdating;
  final String? updateError;

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    String? error,
    DeleteAccountStatus? deleteAccountStatus,
    String? deleteAccountError,
    bool? isUpdating,
    String? updateError,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      error: error,
      deleteAccountStatus: deleteAccountStatus ?? this.deleteAccountStatus,
      deleteAccountError: deleteAccountError,
      isUpdating: isUpdating ?? this.isUpdating,
      updateError: updateError,
    );
  }

  @override
  List<Object?> get props => [
    status,
    profile,
    error,
    deleteAccountStatus,
    deleteAccountError,
    isUpdating,
    updateError,
  ];
}
