import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kStoredPushTokenKey = 'fcm_push_token';

/// Service pour gérer les tokens FCM et les permissions push.
/// Utilisé lors de l'activation/désactivation des notifications dans les paramètres.
class PushNotificationService {
  PushNotificationService(this._messaging, this._prefs);

  final FirebaseMessaging _messaging;
  final SharedPreferences _prefs;

  /// Demande la permission push (requis sur iOS avant getToken).
  Future<bool> requestPermission() async {
    if (!Platform.isIOS) return true;
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  /// Récupère le token FCM actuel.
  /// Retourne null si la permission est refusée ou en cas d'erreur.
  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[PushNotificationService] getToken error: $e');
      }
      return null;
    }
  }

  /// Token enregistré côté backend (pour le retirer lors de la désactivation).
  String? get storedToken => _prefs.getString(_kStoredPushTokenKey);

  /// Enregistre le token localement après envoi au backend.
  Future<void> storeToken(String token) async {
    await _prefs.setString(_kStoredPushTokenKey, token);
  }

  /// Supprime le token stocké après retrait côté backend.
  Future<void> clearStoredToken() async {
    await _prefs.remove(_kStoredPushTokenKey);
  }

  /// Plateforme pour l'enregistrement backend (android | ios).
  static String get platform {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }
}
