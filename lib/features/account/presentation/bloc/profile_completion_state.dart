part of 'profile_completion_cubit.dart';

enum ProfileCompletionStatus {
  initial,
  loading,
  ready,
  saving,
  success,
  failure,
}

class ProfileCompletionState extends Equatable {
  const ProfileCompletionState({
    required this.status,
    this.profile,
    this.healthProfile,
    this.insuranceProvider,
    this.error,
  });

  const ProfileCompletionState.initial()
    : this(status: ProfileCompletionStatus.initial);

  final ProfileCompletionStatus status;
  final UserProfile? profile;
  final HealthProfile? healthProfile;
  final String? insuranceProvider;
  final String? error;

  ProfileCompletionState copyWith({
    ProfileCompletionStatus? status,
    UserProfile? profile,
    HealthProfile? healthProfile,
    String? insuranceProvider,
    String? error,
  }) {
    return ProfileCompletionState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      healthProfile: healthProfile ?? this.healthProfile,
      insuranceProvider: insuranceProvider ?? this.insuranceProvider,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    profile,
    healthProfile,
    insuranceProvider,
    error,
  ];
}
