import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../account/domain/usecases/get_settings.dart';
import '../repositories/notifications_repository.dart';
import '../../../../core/services/push_notification_service.dart';

/// Synchronise le token push avec le backend si les notifications sont activées.
/// À appeler à la connexion et quand le token OneSignal change.
class SyncPushToken {
  SyncPushToken(
    this._getSettings,
    this._notificationsRepo,
    this._pushService,
  );

  final GetSettings _getSettings;
  final NotificationsRepository _notificationsRepo;
  final PushNotificationService _pushService;

  /// Tente d'enregistrer le token auprès du backend si :
  /// - l'utilisateur a les notifications activées
  /// - un token valide est disponible
  Future<Either<Failure, Unit>> call() async {
    final settingsResult = await _getSettings();
    final settings = settingsResult.fold((_) => null, (s) => s);
    if (settings == null || !settings.notificationsEnabled) {
      return settingsResult.fold((f) => Left(f), (_) => const Right(unit));
    }

    final token = await _pushService.getCurrentToken();
    if (token == null || token.length < 10) return const Right(unit);

    final result = await _notificationsRepo.registerPushToken(
      token: token,
      platform: PushNotificationService.platform,
    );
    if (result.isLeft()) return result;
    await _pushService.storeToken(token);
    return const Right(unit);
  }
}
