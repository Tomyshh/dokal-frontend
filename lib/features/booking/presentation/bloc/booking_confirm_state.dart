part of 'booking_confirm_cubit.dart';

enum BookingConfirmStatus { initial, loading, success, failure }

class BookingConfirmState extends Equatable {
  const BookingConfirmState({
    required this.status,
    required this.appointmentId,
    this.error,
  });

  const BookingConfirmState.initial()
    : status = BookingConfirmStatus.initial,
      appointmentId = null,
      error = null;

  final BookingConfirmStatus status;
  final String? appointmentId;
  final String? error;

  BookingConfirmState copyWith({
    BookingConfirmStatus? status,
    String? appointmentId,
    String? error,
  }) {
    return BookingConfirmState(
      status: status ?? this.status,
      appointmentId: appointmentId ?? this.appointmentId,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, appointmentId, error];
}
