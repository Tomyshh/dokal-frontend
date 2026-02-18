import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'l10n/app_localizations.dart';
import 'l10n/app_locale_controller.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'injection_container.dart';
import 'router/app_router.dart';

class DokalApp extends StatelessWidget {
  const DokalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // `AuthBloc` est un singleton (GetIt). On le fournit sans le "dispose".
        BlocProvider<AuthBloc>.value(value: sl<AuthBloc>()),
      ],
      child: ValueListenableBuilder<Locale>(
        valueListenable: AppLocaleController.locale,
        builder: (context, locale, _) {
          return ScreenUtilInit(
            // Base de design standard (iPhone X) — ajustable si vous avez un
            // design Figma différent.
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light(),
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: TextScaler.linear(1.14),
                    ),
                    child: child ?? const SizedBox.shrink(),
                  );
                },
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                localeResolutionCallback: (deviceLocale, supportedLocales) {
                  // Si une locale est fournie via `locale:`, Flutter l’utilise
                  // directement. Ce callback sert de fallback au cas où.
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
              );
            },
          );
        },
      ),
    );
  }
}
