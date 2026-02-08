import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../l10n/l10n_static.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl({required this.remote});

  final NotificationsRemoteDataSource remote;

  @override
  Future<Either<Failure, List<NotificationItem>>> getNotifications() async {
    try {
      final items = await remote.getNotifications();
      return Right(items);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorGenericTryAgain));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await remote.getUnreadCount();
      return Right(count);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorGenericTryAgain));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(String id) async {
    try {
      await remote.markAsRead(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorGenericTryAgain));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAllAsRead() async {
    try {
      await remote.markAllAsRead();
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorGenericTryAgain));
    }
  }

  @override
  Future<Either<Failure, Unit>> registerPushToken({
    required String token,
    required String platform,
  }) async {
    try {
      await remote.registerPushToken(token: token, platform: platform);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorGenericTryAgain));
    }
  }

  @override
  Future<Either<Failure, Unit>> removePushToken(String token) async {
    try {
      await remote.removePushToken(token);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (_) {
      return Left(Failure(l10nStatic.errorGenericTryAgain));
    }
  }
}
