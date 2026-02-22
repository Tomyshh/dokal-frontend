import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/reschedule_appointment.dart';
import 'reschedule_state.dart';

class RescheduleCubit extends Cubit<RescheduleState> {
  RescheduleCubit({
    required RescheduleAppointment rescheduleAppointment,
    required String appointmentId,
    required String practitionerId,
    required String practitionerName,
    required String currentDateLabel,
    required String currentTimeLabel,
  })  : _rescheduleAppointment = rescheduleAppointment,
        super(RescheduleState(
          appointmentId: appointmentId,
          practitionerId: practitionerId,
          practitionerName: practitionerName,
          currentDateLabel: currentDateLabel,
          currentTimeLabel: currentTimeLabel,
        ));

  final RescheduleAppointment _rescheduleAppointment;

  void selectDate(DateTime date) {
    emit(state.copyWith(
      selectedDate: date,
      selectedTime: null,
      selectedEndTime: null,
    ));
  }

  void selectSlot({required String start, required String end}) {
    emit(state.copyWith(
      selectedTime: start,
      selectedEndTime: end,
    ));
  }

  Future<void> confirm() async {
    final date = state.selectedDate;
    final start = state.selectedTime;
    final end = state.selectedEndTime;
    if (date == null || start == null || end == null) return;

    emit(state.copyWith(status: RescheduleStatus.loading));

    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final startFormatted = start.length == 5 ? '$start:00' : start;
    final endFormatted = end.length == 5 ? '$end:00' : end;

    final result = await _rescheduleAppointment(
      state.appointmentId,
      appointmentDate: dateStr,
      startTime: startFormatted,
      endTime: endFormatted,
    );

    result.fold(
      (f) => emit(state.copyWith(
        status: RescheduleStatus.failure,
        error: f.message,
      )),
      (appointment) => emit(state.copyWith(
        status: RescheduleStatus.success,
        updatedAppointment: appointment,
        error: null,
      )),
    );
  }
}
