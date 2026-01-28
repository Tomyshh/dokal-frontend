part of 'health_profile_cubit.dart';

enum HealthProfileStatus { initial, loading, success, failure }

class HealthProfileState extends Equatable {
  const HealthProfileState({
    required this.status,
    required this.profile,
    required this.justSaved,
    this.error,
  });

  const HealthProfileState.initial()
    : status = HealthProfileStatus.initial,
      profile = null,
      justSaved = false,
      error = null;

  final HealthProfileStatus status;
  final HealthProfile? profile;
  final bool justSaved;
  final String? error;

  HealthProfileState copyWith({
    HealthProfileStatus? status,
    HealthProfile? profile,
    bool? justSaved,
    String? error,
  }) {
    return HealthProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      justSaved: justSaved ?? this.justSaved,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, profile, justSaved, error];
}
