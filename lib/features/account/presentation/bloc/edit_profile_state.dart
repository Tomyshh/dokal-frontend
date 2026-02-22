part of 'edit_profile_cubit.dart';

enum EditProfileStatus { initial, loading, success, failure, saveSuccess }

class EditProfileState extends Equatable {
  const EditProfileState({
    required this.status,
    this.profile,
    this.healthProfile,
    this.error,
  });

  const EditProfileState.initial()
    : status = EditProfileStatus.initial,
      profile = null,
      healthProfile = null,
      error = null;

  final EditProfileStatus status;
  final UserProfile? profile;
  final HealthProfile? healthProfile;
  final String? error;

  EditProfileState copyWith({
    EditProfileStatus? status,
    UserProfile? profile,
    HealthProfile? healthProfile,
    String? error,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      healthProfile: healthProfile ?? this.healthProfile,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, profile, healthProfile, error];
}
