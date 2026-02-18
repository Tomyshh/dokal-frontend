import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/notifications_repository.dart';

class RegisterPushToken {
  RegisterPushToken(this.repo);

  final NotificationsRepository repo;

  Future<Either<Failure, Unit>> call({
    required String token,
    required String platform,
  }) => repo.registerPushToken(token: token, platform: platform);
}
