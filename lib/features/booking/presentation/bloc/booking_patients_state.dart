part of 'booking_patients_cubit.dart';

enum BookingPatientsStatus { initial, loading, success, failure }

class BookingPatientsState extends Equatable {
  const BookingPatientsState({
    required this.status,
    required this.me,
    required this.relatives,
    this.error,
  });

  const BookingPatientsState.initial()
    : status = BookingPatientsStatus.initial,
      me = const UserProfile(
        fullName: 'Tom Jami',
        email: 'tom@domaine.com',
        city: '75019 Paris',
      ),
      relatives = const [],
      error = null;

  final BookingPatientsStatus status;
  final UserProfile me;
  final List<Relative> relatives;
  final String? error;

  BookingPatientsState copyWith({
    BookingPatientsStatus? status,
    UserProfile? me,
    List<Relative>? relatives,
    String? error,
  }) {
    return BookingPatientsState(
      status: status ?? this.status,
      me: me ?? this.me,
      relatives: relatives ?? this.relatives,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, me, relatives, error];
}
