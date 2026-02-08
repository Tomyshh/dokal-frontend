import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/notifications_repository.dart';

class GetUnreadCount {
  GetUnreadCount(this.repo);

  final NotificationsRepository repo;

  Future<Either<Failure, int>> call() => repo.getUnreadCount();
}
