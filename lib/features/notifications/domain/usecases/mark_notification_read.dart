import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/notifications_repository.dart';

class MarkNotificationRead {
  MarkNotificationRead(this.repo);

  final NotificationsRepository repo;

  Future<Either<Failure, Unit>> call(String id) => repo.markAsRead(id);
}
