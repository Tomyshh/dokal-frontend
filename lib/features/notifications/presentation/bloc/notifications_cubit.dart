import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/notification_item.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/get_unread_count.dart';
import '../../domain/usecases/mark_all_read.dart';
import '../../domain/usecases/mark_notification_read.dart';
import '../../domain/usecases/register_push_token.dart';
import '../../domain/usecases/remove_push_token.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required this.getNotifications,
    required this.getUnreadCount,
    required this.markNotificationRead,
    required this.markAllRead,
    required this.registerPushToken,
    required this.removePushToken,
  }) : super(const NotificationsState.initial());

  final GetNotifications getNotifications;
  final GetUnreadCount getUnreadCount;
  final MarkNotificationRead markNotificationRead;
  final MarkAllRead markAllRead;
  final RegisterPushToken registerPushToken;
  final RemovePushToken removePushToken;

  Future<void> load() async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    final result = await getNotifications();
    result.fold(
      (f) => emit(
        state.copyWith(status: NotificationsStatus.failure, error: f.message),
      ),
      (items) => emit(
        state.copyWith(status: NotificationsStatus.success, items: items),
      ),
    );
  }

  Future<void> refreshUnread() async {
    final result = await getUnreadCount();
    result.fold((_) {}, (count) => emit(state.copyWith(unreadCount: count)));
  }

  Future<void> markRead(String id) async {
    await markNotificationRead(id);
    await load();
  }

  Future<void> markAllNotificationsRead() async {
    await markAllRead();
    await load();
  }

  Future<void> registerToken(String token, String platform) async {
    await registerPushToken(token: token, platform: platform);
  }

  Future<void> removeToken(String token) async {
    await removePushToken(token);
  }
}
