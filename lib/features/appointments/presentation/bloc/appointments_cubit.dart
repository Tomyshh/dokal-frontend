import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/notifiers/appointment_refresh_notifier.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/usecases/get_past_appointments.dart';
import '../../domain/usecases/get_upcoming_appointments.dart';
import '../../../../l10n/l10n_static.dart';

part 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  AppointmentsCubit({
    required GetUpcomingAppointments getUpcoming,
    required GetPastAppointments getPast,
    required AppointmentRefreshNotifier appointmentRefreshNotifier,
  }) : _getUpcoming = getUpcoming,
       _getPast = getPast,
       _appointmentRefreshNotifier = appointmentRefreshNotifier,
       super(const AppointmentsState.initial()) {
    _appointmentRefreshNotifier.addListener(_onAppointmentsChanged);
  }

  final GetUpcomingAppointments _getUpcoming;
  final GetPastAppointments _getPast;
  final AppointmentRefreshNotifier _appointmentRefreshNotifier;

  void _onAppointmentsChanged() {
    if (!isClosed) load();
  }

  @override
  Future<void> close() {
    _appointmentRefreshNotifier.removeListener(_onAppointmentsChanged);
    return super.close();
  }

  Future<void> load() async {
    // Mode invité: on laisse l'utilisateur voir l'écran RDV sans session.
    // Les RDV "personnels" nécessitent un JWT, donc on ne call pas le backend.
    final hasSession = Supabase.instance.client.auth.currentSession != null;
    if (!hasSession) {
      emit(
        state.copyWith(
          status: AppointmentsStatus.success,
          upcoming: const <Appointment>[],
          past: const <Appointment>[],
          error: null,
        ),
      );
      return;
    }

    emit(state.copyWith(status: AppointmentsStatus.loading));
    final upcomingRes = await _getUpcoming();
    final pastRes = await _getPast();

    final upcomingEither = upcomingRes;
    final pastEither = pastRes;

    if (upcomingEither.isLeft() || pastEither.isLeft()) {
      final msg =
          upcomingEither.fold((l) => l.message, (_) => null) ??
          pastEither.fold((l) => l.message, (_) => null) ??
          l10nStatic.commonError;
      emit(state.copyWith(status: AppointmentsStatus.failure, error: msg));
      return;
    }

    final upcoming = upcomingEither
        .getOrElse(() => const <Appointment>[])
        .where((a) => !a.isCancelled)
        .toList();
    final past = pastEither
        .getOrElse(() => const <Appointment>[])
        .where((a) => !a.isCancelled)
        .toList();

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
