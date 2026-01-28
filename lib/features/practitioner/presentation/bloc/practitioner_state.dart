part of 'practitioner_cubit.dart';

enum PractitionerStatus { initial, loading, success, failure }

class PractitionerState extends Equatable {
  const PractitionerState({
    required this.status,
    required this.practitionerId,
    required this.profile,
    this.error,
  });

  const PractitionerState.initial({required this.practitionerId})
    : status = PractitionerStatus.initial,
      profile = null,
      error = null;

  final PractitionerStatus status;
  final String practitionerId;
  final PractitionerProfile? profile;
  final String? error;

  PractitionerState copyWith({
    PractitionerStatus? status,
    PractitionerProfile? profile,
    String? error,
  }) {
    return PractitionerState(
      status: status ?? this.status,
      practitionerId: practitionerId,
      profile: profile ?? this.profile,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, practitionerId, profile, error];
}
