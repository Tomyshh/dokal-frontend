import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        routerConfig: appRouter,
      ),
    );
  }
}

