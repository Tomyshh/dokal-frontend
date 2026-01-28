part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    required this.status,
    required this.greetingName,
    required this.historyEnabled,
    required this.upcomingAppointments,
    required this.newMessageConversation,
    required this.appointmentHistory,
    this.error,
  });

  const HomeState.initial()
    : status = HomeStatus.initial,
      greetingName = 'Tom',
      historyEnabled = false,
      upcomingAppointments = const [],
      newMessageConversation = null,
      appointmentHistory = const [],
      error = null;

  final HomeStatus status;
  final String greetingName;
  final bool historyEnabled;
  final List<Appointment> upcomingAppointments;
  final ConversationPreview? newMessageConversation;
  final List<Appointment> appointmentHistory;
  final String? error;

  HomeState copyWith({
    HomeStatus? status,
    String? greetingName,
    bool? historyEnabled,
    List<Appointment>? upcomingAppointments,
    ConversationPreview? newMessageConversation,
    List<Appointment>? appointmentHistory,
    String? error,
  }) {
    return HomeState(
      status: status ?? this.status,
      greetingName: greetingName ?? this.greetingName,
      historyEnabled: historyEnabled ?? this.historyEnabled,
      upcomingAppointments: upcomingAppointments ?? this.upcomingAppointments,
      newMessageConversation:
          newMessageConversation ?? this.newMessageConversation,
      appointmentHistory: appointmentHistory ?? this.appointmentHistory,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    greetingName,
    historyEnabled,
    upcomingAppointments,
    newMessageConversation,
    appointmentHistory,
    error,
  ];
}
