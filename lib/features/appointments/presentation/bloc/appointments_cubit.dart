import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/appointment.dart';
import '../../domain/usecases/get_past_appointments.dart';
import '../../domain/usecases/get_upcoming_appointments.dart';

part 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  AppointmentsCubit({
    required GetUpcomingAppointments getUpcoming,
    required GetPastAppointments getPast,
  })  : _getUpcoming = getUpcoming,
        _getPast = getPast,
        super(const AppointmentsState.initial());

  final GetUpcomingAppointments _getUpcoming;
  final GetPastAppointments _getPast;

  Future<void> load() async {
    emit(state.copyWith(status: AppointmentsStatus.loading));
    final upcomingRes = await _getUpcoming();
    final pastRes = await _getPast();

    final upcomingEither = upcomingRes;
    final pastEither = pastRes;

    if (upcomingEither.isLeft() || pastEither.isLeft()) {
      final msg = upcomingEither.fold((l) => l.message, (_) => null) ??
          pastEither.fold((l) => l.message, (_) => null) ??
          'Erreur';
      emit(state.copyWith(status: AppointmentsStatus.failure, error: msg));
      return;
    }

    final upcoming = upcomingEither.getOrElse(() => const []);
    final past = pastEither.getOrElse(() => const []);

    emit(
      state.copyWith(
        status: AppointmentsStatus.success,
        upcoming: upcoming,
        past: past,
        error: null,
      ),
    );
  }
}

