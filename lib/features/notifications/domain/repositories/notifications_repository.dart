import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/notification_item.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<NotificationItem>>> getNotifications();
  Future<Either<Failure, int>> getUnreadCount();
  Future<Either<Failure, Unit>> markAsRead(String id);
  Future<Either<Failure, Unit>> markAllAsRead();
  Future<Either<Failure, Unit>> registerPushToken({
    required String token,
    required String platform,
  });
  Future<Either<Failure, Unit>> removePushToken(String token);
}
