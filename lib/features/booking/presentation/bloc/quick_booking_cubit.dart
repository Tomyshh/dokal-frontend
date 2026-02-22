import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/confirm_booking.dart';

part 'quick_booking_state.dart';

class QuickBookingCubit extends Cubit<QuickBookingState> {
  QuickBookingCubit({
    required ConfirmBooking confirmBooking,
    required String practitionerId,
    required String appointmentDate,
    required String startTime,
    required String endTime,
  })  : _confirmBooking = confirmBooking,
        super(QuickBookingState(
          practitionerId: practitionerId,
          appointmentDate: appointmentDate,
          startTime: startTime,
          endTime: endTime,
        ));

  final ConfirmBooking _confirmBooking;

  void selectPatient({String? relativeId, required String patientLabel}) {
    emit(state.copyWith(
      relativeId: relativeId,
      patientLabel: patientLabel,
    ));
  }

  void goToPatient() {
    emit(state.copyWith(step: QuickBookingStep.patient));
  }

  void goToConfirm() {
    emit(state.copyWith(step: QuickBookingStep.confirm));
  }

  Future<void> confirm() async {
    if (state.patientLabel == null) return;

    emit(state.copyWith(status: QuickBookingStatus.loading));

    final slotLabel =
        '${state.appointmentDate}|${state.startTime}|${state.endTime}';

    final result = await _confirmBooking(
      practitionerId: state.practitionerId,
      reason: '',
      patientLabel: state.patientLabel!,
      slotLabel: slotLabel,
      addressLine: '',
      zipCode: '',
      city: '',
      visitedBefore: false,
      relativeId: state.relativeId,
    );

    result.fold(
      (f) => emit(state.copyWith(
        status: QuickBookingStatus.failure,
        error: f.message,
      )),
      (appointmentId) => emit(state.copyWith(
        status: QuickBookingStatus.success,
        appointmentId: appointmentId,
        error: null,
      )),
    );
  }
}
