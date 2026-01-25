import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/confirm_booking.dart';

part 'booking_confirm_state.dart';

class BookingConfirmCubit extends Cubit<BookingConfirmState> {
  BookingConfirmCubit({required ConfirmBooking confirmBooking})
      : _confirmBooking = confirmBooking,
        super(const BookingConfirmState.initial());

  final ConfirmBooking _confirmBooking;

  Future<void> confirm({
    required String practitionerId,
    required String reason,
    required String patientLabel,
    required String slotLabel,
    required String addressLine,
    required String zipCode,
    required String city,
    required bool visitedBefore,
  }) async {
    emit(state.copyWith(status: BookingConfirmStatus.loading));
    final res = await _confirmBooking(
      practitionerId: practitionerId,
      reason: reason,
      patientLabel: patientLabel,
      slotLabel: slotLabel,
      addressLine: addressLine,
      zipCode: zipCode,
      city: city,
      visitedBefore: visitedBefore,
    );
    res.fold(
      (f) => emit(state.copyWith(status: BookingConfirmStatus.failure, error: f.message)),
      (id) => emit(state.copyWith(status: BookingConfirmStatus.success, appointmentId: id, error: null)),
    );
  }
}

