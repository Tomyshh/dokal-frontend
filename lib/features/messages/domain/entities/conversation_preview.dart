import 'package:equatable/equatable.dart';

class ConversationPreview extends Equatable {
  const ConversationPreview({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.timeAgo,
    required this.unreadCount,
    required this.isOnline,
    required this.avatarColorValue,
    this.avatarUrl,
    this.appointment,
  });

  final String id;
  final String name;
  final String lastMessage;
  final String timeAgo;
  final int unreadCount;
  final bool isOnline;
  final int avatarColorValue;
  final String? avatarUrl;
  final ConversationAppointmentPreview? appointment;

  @override
  List<Object?> get props => [
    id,
    name,
    lastMessage,
    timeAgo,
    unreadCount,
    isOnline,
    avatarColorValue,
    avatarUrl,
    appointment,
  ];
}

class ConversationAppointmentPreview extends Equatable {
  const ConversationAppointmentPreview({
    required this.status,
    required this.date,
    this.title,
    this.isPast = false,
  });

  /// Statut brut de l'API (pending, confirmed, etc.).
  final String status;
  /// Date brute (YYYY-MM-DD).
  final String date;
  /// Titre optionnel (ex. raison du RDV).
  final String? title;
  final bool isPast;

  @override
  List<Object?> get props => [status, date, title, isPast];
}
