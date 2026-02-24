import 'package:flutter/foundation.dart';

import 'onesignal_service.dart';

/// Service pour gérer les tokens push OneSignal et les permissions.
/// Utilisé lors de l'activation/désactivation des notifications dans les paramètres.
/// Délègue à [OneSignalService] pour l'implémentation.
class PushNotificationService {
  PushNotificationService(this._oneSignal);

  final OneSignalService _oneSignal;

  /// Demande la permission push (requis sur iOS avant optIn).
  Future<bool> requestPermission() async {
    return _oneSignal.requestPermission();
  }

  /// Récupère le token actuel sans demander la permission (pour sync/re-enregistrement).
  /// Retourne null si non abonné.
  Future<String?> getCurrentToken() async {
    return _oneSignal.getToken();
  }

  /// Récupère le token (subscription ID) OneSignal.
  /// Appelle optIn puis attend que le token soit disponible.
  /// Retourne null si la permission est refusée ou en cas d'erreur.
  Future<String?> getToken() async {
    try {
      await _oneSignal.optIn();
      // Le token peut ne pas être disponible immédiatement
      return _oneSignal.waitForToken();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[PushNotificationService] getToken error: $e');
      }
      return null;
    }
  }

  /// Token enregistré côté backend (pour le retirer lors de la désactivation).
  String? get storedToken => _oneSignal.storedToken;

  /// Enregistre le token localement après envoi au backend.
  Future<void> storeToken(String token) async {
    await _oneSignal.storeToken(token);
  }

  /// Supprime le token stocké après retrait côté backend.
  Future<void> clearStoredToken() async {
    await _oneSignal.clearStoredToken();
  }

  /// Désactive les notifications push sur l'appareil (opt-out OneSignal).
  Future<void> optOut() async {
    await _oneSignal.optOut();
  }

  /// Plateforme pour l'enregistrement backend (android | ios).
  static String get platform => OneSignalService.platform;
}
