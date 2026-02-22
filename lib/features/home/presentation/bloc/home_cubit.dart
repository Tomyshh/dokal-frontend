import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/notifiers/appointment_refresh_notifier.dart';
import '../../../account/domain/usecases/get_profile.dart';
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
    required GetProfile getProfile,
    required AppointmentRefreshNotifier appointmentRefreshNotifier,
  }) : _getGreetingName = getGreetingName,
       _getHistoryEnabled = getHistoryEnabled,
       _enableHistory = enableHistory,
       _getUpcomingAppointments = getUpcomingAppointments,
       _getPastAppointments = getPastAppointments,
       _getConversations = getConversations,
       _getProfile = getProfile,
       _appointmentRefreshNotifier = appointmentRefreshNotifier,
       super(const HomeState.initial()) {
    _appointmentRefreshNotifier.addListener(_onAppointmentsChanged);
  }

  final GetHomeGreetingName _getGreetingName;
  final GetHomeHistoryEnabled _getHistoryEnabled;
  final EnableHomeHistory _enableHistory;
  final GetUpcomingAppointments _getUpcomingAppointments;
  final GetPastAppointments _getPastAppointments;
  final GetConversations _getConversations;
  final GetProfile _getProfile;
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
    if (isClosed) return;
    emit(state.copyWith(status: HomeStatus.loading));
    final nameRes = await _getGreetingName();
    if (isClosed) return;
    final histRes = await _getHistoryEnabled();
    if (isClosed) return;

    // Mode invité: ne pas appeler les endpoints privés (RDV / messages).
    final hasSession = Supabase.instance.client.auth.currentSession != null;
    final Either<Failure, List<Appointment>> upcomingRes = hasSession
        ? await _getUpcomingAppointments()
        : const Right<Failure, List<Appointment>>(<Appointment>[]);
    if (isClosed) return;
    final Either<Failure, List<Appointment>> pastRes = hasSession
        ? await _getPastAppointments()
        : const Right<Failure, List<Appointment>>(<Appointment>[]);
    if (isClosed) return;
    final Either<Failure, List<ConversationPreview>> convRes = hasSession
        ? await _getConversations()
        : const Right<Failure, List<ConversationPreview>>(
            <ConversationPreview>[],
          );
    if (isClosed) return;

    // Profil (best effort pour récupérer l'avatar)
    String? avatarUrl;
    if (hasSession) {
      final profileRes = await _getProfile();
      profileRes.fold((_) {}, (p) => avatarUrl = p.avatarUrl);
    }
    if (isClosed) return;

    // Localisation (best effort)
    final location = await _fetchLocation();

    String? error;
    String name = '—';
    bool enabled = false;

    nameRes.fold((f) => error ??= f.message, (v) => name = v);
    histRes.fold((f) => error ??= f.message, (v) => enabled = v);

    if (error != null) {
      if (!isClosed) emit(state.copyWith(status: HomeStatus.failure, error: error));
      return;
    }

    // Appointments are "best effort" for now (so the Home stays usable offline/demo).
    final upcoming = upcomingRes.getOrElse(() => const <Appointment>[]);
    final past = pastRes.getOrElse(() => const <Appointment>[]);

    final upcomingList = upcoming
        .where((a) => !a.isCancelled)
        .take(3)
        .toList(growable: false);
    final history = past
        .where((a) => !a.isCancelled)
        .take(3)
        .toList(growable: false);

    final conversations = convRes.getOrElse(
      () => const <ConversationPreview>[],
    );
    final newMessage = conversations.cast<ConversationPreview?>().firstWhere(
      (c) => (c?.unreadCount ?? 0) > 0,
      orElse: () => null,
    );

    if (!isClosed) {
      emit(
        state.copyWith(
          status: HomeStatus.success,
          greetingName: name,
          historyEnabled: enabled,
          upcomingAppointments: upcomingList,
          newMessageConversation: newMessage,
          appointmentHistory: history,
          avatarUrl: avatarUrl,
          city: location.$1,
          country: location.$2,
          error: null,
        ),
      );
    }
  }

  Future<(String, String)> _fetchLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return ('', '');

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return ('', '');
      }
      if (permission == LocationPermission.deniedForever) return ('', '');

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 8),
        ),
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isEmpty) return ('', '');
      final p = placemarks.first;
      final city = p.locality?.isNotEmpty == true
          ? p.locality!
          : (p.subAdministrativeArea ?? '');
      final country = p.country ?? '';
      return (city, country);
    } catch (_) {
      return ('', '');
    }
  }

  Future<void> activateHistory() async {
    if (isClosed) return;
    emit(state.copyWith(status: HomeStatus.loading));
    final res = await _enableHistory();
    if (isClosed) return;
    res.fold(
      (f) {
        if (!isClosed) emit(state.copyWith(status: HomeStatus.failure, error: f.message));
      },
      (_) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: HomeStatus.success,
              historyEnabled: true,
              error: null,
            ),
          );
        }
      },
    );
  }
}
