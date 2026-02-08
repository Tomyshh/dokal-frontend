import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/notifications_repository.dart';

class MarkAllRead {
  MarkAllRead(this.repo);

  final NotificationsRepository repo;

  Future<Either<Failure, Unit>> call() => repo.markAllAsRead();
}
