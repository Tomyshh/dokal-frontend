import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/profile_completion/profile_completion_notifier.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'firebase_options.dart';
import 'injection_container.dart';
import 'l10n/app_locale_controller.dart';
import 'router/app_router.dart';

/// Handler pour les messages FCM reçus en arrière-plan ou quand l'app est fermée.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Traitement optionnel des données de la notification
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  configureDependencies();
  await sl.allReady();
  await AppLocaleController.init();
  final authBloc = sl<AuthBloc>();
  final profileCompletion = sl<ProfileCompletionNotifier>();
  final prefs = sl<SharedPreferences>();
  initAppRouter(
    authBloc,
    isOnboardingCompleted: () => prefs.getBool('onboarding_completed') ?? false,
    profileCompletion: profileCompletion,
  );
  // Déclenche le check session dès le démarrage.
  authBloc.add(const AuthStarted());
  runApp(const DokalApp());
}
