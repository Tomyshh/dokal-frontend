import 'dart:ui' show PlatformDispatcher;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show FlutterError, kDebugMode;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/profile_completion/profile_completion_notifier.dart';
import 'core/services/onesignal_service.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'firebase_options.dart';
import 'injection_container.dart';
import 'l10n/app_locale_controller.dart';
import 'router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // OneSignal : initialisation avec l'App ID depuis .env.prod / Render
  const oneSignalAppId = String.fromEnvironment(
    'ONESIGNAL_APP_ID',
    defaultValue: '',
  );
  await OneSignalService.initialize(oneSignalAppId);

  // Crashlytics : capture des erreurs Flutter et asynchrones
  FlutterError.onError = (details) {
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      debugPrint('PlatformDispatcher error: $error\n$stack');
    }
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

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
