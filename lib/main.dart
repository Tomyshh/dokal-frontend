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
    isPermissionsCompleted: () => prefs.getBool('permissions_completed') ?? false,
    profileCompletion: profileCompletion,
  );

  // Deep links : clic sur notification push (CRM → app mobile)
  OneSignalService.setupNotificationClickHandler(_handleNotificationClick);

  // Déclenche le check session dès le démarrage.
  authBloc.add(const AuthStarted());
  runApp(const DokalApp());
}

void _handleNotificationClick(Map<String, dynamic>? data) {
  if (data == null || data.isEmpty) return;
  final type = data['type'] as String?;
  final conversationId = data['conversation_id'] as String?;
  final appointmentId = data['appointment_id'] as String?;

  if (type == 'new_message' && conversationId != null) {
    appRouter.go('/messages/c/$conversationId');
  } else if (appointmentId != null &&
      (type == 'appointment_cancelled' ||
          type == 'appointment_confirmed' ||
          type == 'appointment_request' ||
          type == 'appointment_reminder')) {
    appRouter.go('/appointments/$appointmentId');
  } else if (type == 'review_received') {
    appRouter.go('/account');
  } else {
    appRouter.go('/home');
  }
}
