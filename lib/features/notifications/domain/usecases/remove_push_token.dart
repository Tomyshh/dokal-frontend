import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/notifications_repository.dart';

class RemovePushToken {
  RemovePushToken(this.repo);

  final NotificationsRepository repo;

  Future<Either<Failure, Unit>> call(String token) => repo.removePushToken(token);
}
