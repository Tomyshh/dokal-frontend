import '../../../../core/network/api_client.dart';
import '../../domain/entities/notification_item.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationItem>> getNotifications();
  Future<int> getUnreadCount();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<void> registerPushToken({
    required String token,
    required String platform,
  });
  Future<void> removePushToken(String token);
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  NotificationsRemoteDataSourceImpl({required this.api});

  final ApiClient api;

  @override
  Future<List<NotificationItem>> getNotifications() async {
    final data = await api.get('/api/v1/notifications') as List<dynamic>;

    return data.map((raw) {
      final json = raw as Map<String, dynamic>;
      return NotificationItem(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        type: json['type'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        data: json['data'] as Map<String, dynamic>? ?? <String, dynamic>{},
        isRead: json['is_read'] as bool? ?? false,
        createdAt: json['created_at'] as String,
      );
    }).toList();
  }

  @override
  Future<int> getUnreadCount() async {
    final json =
        await api.get('/api/v1/notifications/unread-count')
            as Map<String, dynamic>;
    return json['count'] as int? ?? 0;
  }

  @override
  Future<void> markAsRead(String id) async {
    await api.patch('/api/v1/notifications/$id/read');
  }

  @override
  Future<void> markAllAsRead() async {
    await api.patch('/api/v1/notifications/read-all');
  }

  @override
  Future<void> registerPushToken({
    required String token,
    required String platform,
  }) async {
    await api.post(
      '/api/v1/notifications/push-tokens',
      data: {'token': token, 'platform': platform},
    );
  }

  @override
  Future<void> removePushToken(String token) async {
    await api.delete(
      '/api/v1/notifications/push-tokens',
      data: {'token': token},
    );
  }
}
