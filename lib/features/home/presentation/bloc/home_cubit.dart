import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failure.dart';
import '../../../appointments/domain/entities/appointment.dart';
import '../../../appointments/domain/usecases/get_past_appointments.dart';
import '../../../appointments/domain/usecases/get_upcoming_appointments.dart';
import '../../../messages/domain/entities/conversation_preview.dart';
import '../../../messages/domain/usecases/get_conversations.dart';
import '../../domain/usecases/enable_home_history.dart';
import '../../domain/usecases/get_home_greeting_name.dart';
import '../../domain/usecases/get_home_history_enabled.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required GetHomeGreetingName getGreetingName,
    required GetHomeHistoryEnabled getHistoryEnabled,
    required EnableHomeHistory enableHistory,
    required GetUpcomingAppointments getUpcomingAppointments,
    required GetPastAppointments getPastAppointments,
    required GetConversations getConversations,
  }) : _getGreetingName = getGreetingName,
       _getHistoryEnabled = getHistoryEnabled,
       _enableHistory = enableHistory,
       _getUpcomingAppointments = getUpcomingAppointments,
       _getPastAppointments = getPastAppointments,
       _getConversations = getConversations,
       super(const HomeState.initial());

  final GetHomeGreetingName _getGreetingName;
  final GetHomeHistoryEnabled _getHistoryEnabled;
  final EnableHomeHistory _enableHistory;
  final GetUpcomingAppointments _getUpcomingAppointments;
  final GetPastAppointments _getPastAppointments;
  final GetConversations _getConversations;

  Future<void> load() async {
    emit(state.copyWith(status: HomeStatus.loading));
    final nameRes = await _getGreetingName();
    final histRes = await _getHistoryEnabled();

    // Mode invité: ne pas appeler les endpoints privés (RDV / messages).
    final hasSession = Supabase.instance.client.auth.currentSession != null;
    final Either<Failure, List<Appointment>> upcomingRes = hasSession
        ? await _getUpcomingAppointments()
        : const Right<Failure, List<Appointment>>(<Appointment>[]);
    final Either<Failure, List<Appointment>> pastRes = hasSession
        ? await _getPastAppointments()
        : const Right<Failure, List<Appointment>>(<Appointment>[]);
    final Either<Failure, List<ConversationPreview>> convRes = hasSession
        ? await _getConversations()
        : const Right<Failure, List<ConversationPreview>>(
            <ConversationPreview>[],
          );

    String? error;
    String name = '—';
    bool enabled = false;

    nameRes.fold((f) => error ??= f.message, (v) => name = v);
    histRes.fold((f) => error ??= f.message, (v) => enabled = v);

    if (error != null) {
      emit(state.copyWith(status: HomeStatus.failure, error: error));
      return;
    }

    // Appointments are "best effort" for now (so the Home stays usable offline/demo).
    final upcoming = upcomingRes.getOrElse(() => const <Appointment>[]);
    final past = pastRes.getOrElse(() => const <Appointment>[]);

    final upcomingList = upcoming.take(3).toList(growable: false);
    final history = past.take(3).toList(growable: false);

    final conversations = convRes.getOrElse(
      () => const <ConversationPreview>[],
    );
    final newMessage = conversations.cast<ConversationPreview?>().firstWhere(
      (c) => (c?.unreadCount ?? 0) > 0,
      orElse: () => null,
    );

    emit(
      state.copyWith(
        status: HomeStatus.success,
        greetingName: name,
        historyEnabled: enabled,
        upcomingAppointments: upcomingList,
        newMessageConversation: newMessage,
        appointmentHistory: history,
        error: null,
      ),
    );
  }

  Future<void> activateHistory() async {
    emit(state.copyWith(status: HomeStatus.loading));
    final res = await _enableHistory();
    res.fold(
      (f) => emit(state.copyWith(status: HomeStatus.failure, error: f.message)),
      (_) => emit(
        state.copyWith(
          status: HomeStatus.success,
          historyEnabled: true,
          error: null,
        ),
      ),
    );
  }
}
