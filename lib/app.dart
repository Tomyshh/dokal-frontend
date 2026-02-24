import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'l10n/app_localizations.dart';
import 'l10n/app_locale_controller.dart';

import 'core/services/onesignal_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/notifications/domain/usecases/sync_push_token.dart';
import 'injection_container.dart';
import 'router/app_router.dart';

class DokalApp extends StatefulWidget {
  const DokalApp({super.key});

  @override
  State<DokalApp> createState() => _DokalAppState();
}

class _DokalAppState extends State<DokalApp> {
  static bool _tokenObserverSetup = false;

  @override
  void initState() {
    super.initState();
    _setupTokenChangeObserver();
  }

  void _setupTokenChangeObserver() {
    if (_tokenObserverSetup) return;
    _tokenObserverSetup = true;
    OneSignalService.addTokenChangeObserver(() {
      sl<SyncPushToken>().call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // `AuthBloc` est un singleton (GetIt). On le fournit sans le "dispose".
        BlocProvider<AuthBloc>.value(value: sl<AuthBloc>()),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isAuthenticated && state.session != null) {
            OneSignalService.login(state.session!.userId);
            // Re-enregistrer le token si les notifications sont activées
            sl<SyncPushToken>().call();
          } else if (state.status == AuthStatus.unauthenticated ||
              state.status == AuthStatus.loggingOut) {
            OneSignalService.logout();
          }
        },
        child: ValueListenableBuilder<Locale>(
        valueListenable: AppLocaleController.locale,
        builder: (context, locale, _) {
          final isRtl = locale.languageCode == 'he' || locale.languageCode == 'ar';
          final textDirection = isRtl ? TextDirection.rtl : TextDirection.ltr;
          return ScreenUtilInit(
            // Base de design standard (iPhone X) — ajustable si vous avez un
            // design Figma différent.
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return Directionality(
                textDirection: textDirection,
                child: MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.light(),
                  builder: (context, child) {
                    return Directionality(
                      textDirection: textDirection,
                      child: MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaler: TextScaler.linear(1.00),
                        ),
                        child: child ?? const SizedBox.shrink(),
                      ),
                    );
                  },
                  locale: locale,
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  localeResolutionCallback: (deviceLocale, supportedLocales) {
                    final l = deviceLocale;
                    if (l == null) return const Locale('he');
                    for (final supported in supportedLocales) {
                      if (supported.languageCode == l.languageCode) {
                        return supported;
                      }
                    }
                    return const Locale('he');
                  },
                  routerConfig: appRouter,
                ),
              );
            },
          );
        },
      ),
    ),
    );
  }
}
