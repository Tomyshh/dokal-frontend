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
    this.avatarUrl,
    this.city,
    this.country,
    this.error,
  });

  const HomeState.initial()
    : status = HomeStatus.initial,
      greetingName = '',
      historyEnabled = false,
      upcomingAppointments = const [],
      newMessageConversation = null,
      appointmentHistory = const [],
      avatarUrl = null,
      city = null,
      country = null,
      error = null;

  final HomeStatus status;
  final String greetingName;
  final bool historyEnabled;
  final List<Appointment> upcomingAppointments;
  final ConversationPreview? newMessageConversation;
  final List<Appointment> appointmentHistory;
  final String? avatarUrl;
  final String? city;
  final String? country;
  final String? error;

  HomeState copyWith({
    HomeStatus? status,
    String? greetingName,
    bool? historyEnabled,
    List<Appointment>? upcomingAppointments,
    ConversationPreview? newMessageConversation,
    List<Appointment>? appointmentHistory,
    String? avatarUrl,
    String? city,
    String? country,
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
      avatarUrl: avatarUrl ?? this.avatarUrl,
      city: city ?? this.city,
      country: country ?? this.country,
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
    avatarUrl,
    city,
    country,
    error,
  ];
}
