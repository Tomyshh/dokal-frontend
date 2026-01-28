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
    this.appointment,
  });

  final String id;
  final String name;
  final String lastMessage;
  final String timeAgo;
  final int unreadCount;
  final bool isOnline;
  final int avatarColorValue;
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
    appointment,
  ];
}

class ConversationAppointmentPreview extends Equatable {
  const ConversationAppointmentPreview({
    required this.title,
    required this.date,
    this.isPast = false,
  });

  final String title;
  final String date;
  final bool isPast;

  @override
  List<Object?> get props => [title, date, isPast];
}
