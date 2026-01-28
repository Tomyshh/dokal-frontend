part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  const ProfileState({required this.status, required this.profile, this.error});

  const ProfileState.initial()
    : status = ProfileStatus.initial,
      profile = null,
      error = null;

  final ProfileStatus status;
  final UserProfile? profile;
  final String? error;

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    String? error,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, profile, error];
}
