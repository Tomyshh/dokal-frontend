part of 'notifications_cubit.dart';

enum NotificationsStatus { initial, loading, success, failure }

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.items = const [],
    this.unreadCount = 0,
    this.error,
  });

  const NotificationsState.initial() : this();

  final NotificationsStatus status;
  final List<NotificationItem> items;
  final int unreadCount;
  final String? error;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationItem>? items,
    int? unreadCount,
    String? error,
  }) =>
      NotificationsState(
        status: status ?? this.status,
        items: items ?? this.items,
        unreadCount: unreadCount ?? this.unreadCount,
        error: error,
      );

  @override
  List<Object?> get props => [status, items, unreadCount, error];
}
