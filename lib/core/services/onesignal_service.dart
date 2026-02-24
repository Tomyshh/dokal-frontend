import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kStoredPushTokenKey = 'onesignal_push_subscription_id';

/// Service pour gérer OneSignal : initialisation, tokens et permissions push.
/// Utilisé lors de l'activation/désactivation des notifications dans les paramètres.
class OneSignalService {
  OneSignalService(this._prefs);

  final SharedPreferences _prefs;

  /// Initialise OneSignal avec l'App ID.
  /// À appeler une seule fois au démarrage de l'app.
  /// Ignoré sur web (OneSignal Flutter n'a pas d'implémentation native web).
  static Future<void> initialize(String appId) async {
    if (kIsWeb) return;
    if (appId.isEmpty) {
      if (kDebugMode) {
        debugPrint('[OneSignalService] ONESIGNAL_APP_ID vide, OneSignal non initialisé');
      }
      return;
    }

    try {
      if (kDebugMode) {
        OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      }
      OneSignal.initialize(appId);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OneSignalService] initialize error (ignored): $e');
      }
    }
  }

  /// Définit l'External ID pour identifier l'utilisateur côté OneSignal.
  /// À appeler après connexion.
  /// Ignoré sur web (OneSignal Flutter n'a pas d'implémentation native web).
  static Future<void> login(String userId) async {
    if (userId.isEmpty) return;
    if (kIsWeb) return;
    // Différer légèrement pour laisser le plugin natif s'enregistrer
    await Future<void>.delayed(Duration.zero);
    try {
      OneSignal.login(userId);
      if (kDebugMode) {
        debugPrint('[OneSignalService] External ID défini: $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OneSignalService] login error (ignored): $e');
      }
    }
  }

  /// Déconnecte l'utilisateur OneSignal (à la déconnexion).
  /// Ignoré sur web.
  static Future<void> logout() async {
    if (kIsWeb) return;
    try {
      OneSignal.logout();
      if (kDebugMode) {
        debugPrint('[OneSignalService] Utilisateur déconnecté');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OneSignalService] logout error (ignored): $e');
      }
    }
  }

  /// Demande la permission push (requis sur iOS avant optIn).
  /// Retourne true si la permission est accordée.
  Future<bool> requestPermission() async {
    if (!Platform.isIOS) return true;
    final granted = await OneSignal.Notifications.requestPermission(false);
    return granted;
  }

  /// Active les notifications push (opt-in) et demande la permission si nécessaire.
  Future<void> optIn() async {
    await OneSignal.User.pushSubscription.optIn();
  }

  /// Désactive les notifications push sur l'appareil.
  Future<void> optOut() async {
    await OneSignal.User.pushSubscription.optOut();
  }

  /// Récupère le token (subscription ID) OneSignal.
  /// Retourne null si non abonné ou en cas d'erreur.
  /// Le subscription ID est l'identifiant unique à envoyer au backend.
  Future<String?> getToken() async {
    try {
      final id = OneSignal.User.pushSubscription.id;
      if (id != null && id.isNotEmpty) return id;
      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OneSignalService] getToken error: $e');
      }
      return null;
    }
  }

  /// Attend que le subscription soit disponible (avec timeout).
  /// Utile car l'ID peut ne pas être disponible immédiatement après optIn.
  Future<String?> waitForToken({Duration timeout = const Duration(seconds: 10)}) async {
    String? id = OneSignal.User.pushSubscription.id;
    if (id != null && id.isNotEmpty) return id;

    const interval = Duration(milliseconds: 500);
    var elapsed = Duration.zero;
    while (elapsed < timeout) {
      await Future<void>.delayed(interval);
      elapsed += interval;
      id = OneSignal.User.pushSubscription.id;
      if (id != null && id.isNotEmpty) return id;
    }
    return OneSignal.User.pushSubscription.id;
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

  /// Configure le handler de clic sur les notifications push (deep links).
  /// À appeler après l'initialisation du router.
  /// Utilise additionalData (type, conversation_id, appointment_id) pour la navigation.
  static void setupNotificationClickHandler(
    void Function(Map<String, dynamic>? data) onNotificationClicked,
  ) {
    if (kIsWeb) return;
    try {
      OneSignal.Notifications.addClickListener((event) {
        final additionalData = event.notification.additionalData;
        if (additionalData != null && additionalData.isNotEmpty) {
          onNotificationClicked(additionalData);
        } else {
          onNotificationClicked(null);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OneSignalService] setupNotificationClickHandler error: $e');
      }
    }
  }

  /// Enregistre un callback appelé quand le token (subscription ID) change.
  /// Utile pour re-enregistrer le token auprès du backend.
  static void addTokenChangeObserver(void Function() onTokenChanged) {
    if (kIsWeb) return;
    try {
      OneSignal.User.pushSubscription.addObserver((_) {
        final id = OneSignal.User.pushSubscription.id;
        if (id != null && id.isNotEmpty) {
          onTokenChanged();
        }
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OneSignalService] addTokenChangeObserver error: $e');
      }
    }
  }
}
