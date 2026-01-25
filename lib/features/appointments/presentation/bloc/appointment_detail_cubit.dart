import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/appointment.dart';
import '../../domain/usecases/cancel_appointment.dart';
import '../../domain/usecases/get_appointment_detail.dart';

part 'appointment_detail_state.dart';

class AppointmentDetailCubit extends Cubit<AppointmentDetailState> {
  AppointmentDetailCubit({
    required GetAppointmentDetail getAppointmentDetail,
    required CancelAppointment cancelAppointment,
    required String appointmentId,
  })  : _getAppointmentDetail = getAppointmentDetail,
        _cancelAppointment = cancelAppointment,
        super(AppointmentDetailState.initial(appointmentId: appointmentId));

  final GetAppointmentDetail _getAppointmentDetail;
  final CancelAppointment _cancelAppointment;

  Future<void> load() async {
    emit(state.copyWith(status: AppointmentDetailStatus.loading));
    final res = await _getAppointmentDetail(state.appointmentId);
    res.fold(
      (f) => emit(state.copyWith(status: AppointmentDetailStatus.failure, error: f.message)),
      (appointment) => emit(
        state.copyWith(
          status: AppointmentDetailStatus.success,
          appointment: appointment,
          error: null,
        ),
      ),
    );
  }

  Future<void> cancel() async {
    emit(state.copyWith(status: AppointmentDetailStatus.loading));
    final res = await _cancelAppointment(state.appointmentId);
    res.fold(
      (f) => emit(state.copyWith(status: AppointmentDetailStatus.failure, error: f.message)),
      (_) => emit(
        state.copyWith(
          status: AppointmentDetailStatus.success,
          appointment: null,
          error: null,
        ),
      ),
    );
  }
}

