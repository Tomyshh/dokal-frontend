import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/notification_item.dart';
import '../repositories/notifications_repository.dart';

class GetNotifications {
  GetNotifications(this.repo);

  final NotificationsRepository repo;

  Future<Either<Failure, List<NotificationItem>>> call() =>
      repo.getNotifications();
}
