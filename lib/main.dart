import 'package:flutter/material.dart';

import 'app.dart';
import 'injection_container.dart';
import 'l10n/app_locale_controller.dart';
import 'router/app_router.dart';
import 'core/profile_completion/profile_completion_notifier.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
