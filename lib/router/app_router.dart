import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/utils/go_router_refresh_stream.dart';
import '../core/profile_completion/profile_completion_notifier.dart';
import '../core/widgets/main_shell.dart';
import '../features/account/presentation/pages/account_page.dart';
import '../features/appointments/presentation/pages/appointments_page.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/onboarding_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/reset_password_page.dart';
import '../features/auth/presentation/pages/verify_password_reset_otp_page.dart';
import '../features/auth/presentation/pages/verify_email_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/health/presentation/pages/health_dashboard_page.dart';
import '../features/health/presentation/pages/health_profile_workflow_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/messages/presentation/pages/messages_list_page.dart';
import '../features/practitioner/presentation/pages/practitioner_profile_page.dart';
import '../features/search/presentation/pages/search_page.dart';
import '../features/booking/presentation/pages/booking_flow_shell.dart';
import '../features/booking/presentation/pages/booking_success_page.dart';
import '../features/booking/presentation/pages/confirm_booking_page.dart';
import '../features/booking/presentation/pages/instructions_page.dart';
import '../features/booking/presentation/pages/select_patient_page.dart';
import '../features/booking/presentation/pages/select_reason_page.dart';
import '../features/booking/presentation/pages/select_slot_page.dart';
import '../features/appointments/presentation/pages/appointment_detail_page.dart';
import '../features/appointments/presentation/pages/appointment_instructions_page.dart';
import '../features/appointments/presentation/pages/appointment_questionnaire_page.dart';
import '../features/messages/presentation/pages/new_message_page.dart';
import '../features/messages/presentation/pages/conversation_page.dart';
import '../features/health/presentation/pages/allergies_page.dart';
import '../features/health/presentation/pages/medical_conditions_page.dart';
import '../features/health/presentation/pages/medications_page.dart';
import '../features/health/presentation/pages/vaccinations_page.dart';
import '../features/account/presentation/pages/profile_page.dart';
import '../features/account/presentation/pages/relatives_page.dart';
import '../features/account/presentation/pages/security_page.dart';
import '../features/account/presentation/pages/security/change_password_page.dart';
import '../features/account/presentation/pages/payment_page.dart';
import '../features/account/presentation/pages/settings_page.dart';
import '../features/account/presentation/pages/privacy_page.dart';
import '../features/account/presentation/pages/complete_patient_profile_wizard_page.dart';

late final GoRouter appRouter;
late final AuthBloc _authBloc;
late final bool Function() _isOnboardingCompleted;
late final ProfileCompletionNotifier _profileCompletion;

final _rootNavKey = GlobalKey<NavigatorState>();
final _homeTabNavKey = GlobalKey<NavigatorState>(debugLabel: 'homeTab');
final _appointmentsTabNavKey = GlobalKey<NavigatorState>(
  debugLabel: 'appointmentsTab',
);
final _messagesTabNavKey = GlobalKey<NavigatorState>(debugLabel: 'messagesTab');
final _accountTabNavKey = GlobalKey<NavigatorState>(debugLabel: 'accountTab');

/// Routes qui nécessitent une authentification
/// Seulement le booking - l'onglet Compte affiche le login inline si besoin
const _protectedRoutes = ['/booking', '/complete-profile'];

/// Vérifie si une route nécessite une authentification
bool _isProtectedRoute(String location) {
  return _protectedRoutes.any((route) => location.startsWith(route));
}

/// Vérifie si l'utilisateur est authentifié
bool isUserAuthenticated() {
  return _authBloc.state.isAuthenticated;
}

/// Validation simple de la destination `redirect` (anti open-redirect).
/// Retourne une location interne (ex: `/home/search?x=1`) ou `null`.
String? _safeRedirectTarget(GoRouterState state) {
  final raw = state.uri.queryParameters['redirect'];
  if (raw == null || raw.trim().isEmpty) return null;

  final decoded = Uri.decodeComponent(raw.trim());
  final uri = Uri.tryParse(decoded);
  if (uri == null) return null;

  // Refuser tout redirect externe.
  if (uri.hasScheme || (uri.host.isNotEmpty)) return null;

  final path = uri.path;
  if (!path.startsWith('/')) return null;

  // Refuser de reboucler sur des routes d'auth.
  const authPaths = {
    '/onboarding',
    '/login',
    '/register',
    '/forgot-password',
    '/forgot-password/verify',
    '/forgot-password/reset',
    '/verify-email',
    '/splash',
  };
  if (authPaths.contains(path)) return null;

  return uri.toString();
}

void initAppRouter(
  AuthBloc authBloc, {
  required bool Function() isOnboardingCompleted,
  required ProfileCompletionNotifier profileCompletion,
}) {
  _authBloc = authBloc;
  _isOnboardingCompleted = isOnboardingCompleted;
  _profileCompletion = profileCompletion;

  // Keep profile completion state in sync with auth.
  _authBloc.stream.listen((state) {
    if (state.isAuthenticated) {
      _profileCompletion.refresh();
    } else {
      _profileCompletion.reset();
    }
  });

  appRouter = GoRouter(
    navigatorKey: _rootNavKey,
    // On démarre sur un splash qui décide (auth + onboarding).
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    refreshListenable: Listenable.merge([
      GoRouterRefreshStream(authBloc.stream),
      _profileCompletion,
    ]),
    redirect: (context, state) {
      // `path` = chemin courant sans query (stable pour les checks)
      // `full` = destination complète à restaurer après login (avec query)
      final path = state.uri.path;
      final full = state.uri.toString();
      final isAuthRoute =
          path == '/onboarding' ||
          path == '/login' ||
          path == '/register' ||
          path == '/forgot-password' ||
          path == '/forgot-password/verify' ||
          path == '/forgot-password/reset' ||
          path == '/verify-email';

      final isAuthed = authBloc.state.isAuthenticated;
      final onboardingCompleted = _isOnboardingCompleted();

      // Enforce required patient info completion once authenticated.
      const completionPath = '/complete-profile';
      if (isAuthed) {
        // Trigger a refresh the first time we need the info.
        if (_profileCompletion.status == ProfileGuardStatus.unknown) {
          _profileCompletion.refresh();
        }

        if (_profileCompletion.needsCompletion && path != completionPath) {
          return '$completionPath?redirect=${Uri.encodeComponent(full)}';
        }
        if (!_profileCompletion.needsCompletion && path == completionPath) {
          // Ne pas quitter le wizard pendant le refresh (ex. après sauvegarde).
          if (_profileCompletion.status == ProfileGuardStatus.loading) {
            return null;
          }
          final target = _safeRedirectTarget(state);
          return target ?? '/home';
        }
      } else {
        if (path == completionPath) return '/home';
      }

      // Si quelqu'un arrive sur /splash, on le sort immédiatement.
      if (path == '/splash') {
        if (isAuthed) return '/home';
        if (onboardingCompleted) return '/home';
        return '/onboarding';
      }

      // Si onboarding déjà terminé, ne pas y revenir.
      if (path == '/onboarding' && onboardingCompleted) return '/home';

      // Si authentifié et sur une route d'auth (login, register, etc.), aller au home
      if (isAuthed && isAuthRoute) {
        final target = _safeRedirectTarget(state);
        return target ?? '/home';
      }

      // Les routes protégées nécessitent une authentification
      if (!isAuthed && _isProtectedRoute(path)) {
        // Rediriger vers login avec la destination originale
        return '/login?redirect=${Uri.encodeComponent(full)}';
      }

      return null;
    },
    routes: [
      // Fallback robuste: certaines navigations/back-stack peuvent retomber sur `/`.
      GoRoute(
        path: '/',
        redirect: (context, state) {
          // Évite une chaîne `/` -> `/splash` -> ...
          final isAuthed = _authBloc.state.isAuthenticated;
          final onboardingCompleted = _isOnboardingCompleted();
          if (isAuthed) return '/home';
          if (onboardingCompleted) return '/home';
          return '/onboarding';
        },
      ),
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: '/complete-profile',
        builder: (context, state) => const CompletePatientProfileWizardPage(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          final redirect = state.uri.queryParameters['redirect'];
          return LoginPage(redirectTo: redirect);
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          final redirect = state.uri.queryParameters['redirect'];
          return RegisterPage(redirectTo: redirect);
        },
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/forgot-password/verify',
        builder: (context, state) => VerifyPasswordResetOtpPage(
          email: (state.extra as String?) ?? '',
        ),
      ),
      GoRoute(
        path: '/forgot-password/reset',
        builder: (context, state) =>
            ResetPasswordPage(email: (state.extra as String?) ?? ''),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) =>
            VerifyEmailPage(email: (state.extra as String?) ?? ''),
      ),
      GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
      GoRoute(
        path: '/practitioner/:id',
        builder: (context, state) => PractitionerProfilePage(
          practitionerId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/booking/:practitionerId',
        redirect: (context, state) =>
            '/booking/${state.pathParameters['practitionerId']!}/reason',
      ),
      ShellRoute(
        builder: (context, state, child) => BookingFlowShell(
          practitionerId: state.pathParameters['practitionerId']!,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/booking/:practitionerId/reason',
            builder: (context, state) => const SelectReasonPage(),
          ),
          GoRoute(
            path: '/booking/:practitionerId/patient',
            builder: (context, state) => const SelectPatientPage(),
          ),
          GoRoute(
            path: '/booking/:practitionerId/instructions',
            builder: (context, state) => const InstructionsPage(),
          ),
          GoRoute(
            path: '/booking/:practitionerId/slot',
            builder: (context, state) => const SelectSlotPage(),
          ),
          GoRoute(
            path: '/booking/:practitionerId/confirm',
            builder: (context, state) => const ConfirmBookingPage(),
          ),
          GoRoute(
            path: '/booking/:practitionerId/success',
            builder: (context, state) => const BookingSuccessPage(),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeTabNavKey,
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) {
                  final isAuthed = _authBloc.state.isAuthenticated;
                  return NoTransitionPage(
                    key: ValueKey('home-$isAuthed'),
                    child: const HomePage(),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'search',
                    builder: (context, state) => const SearchPage(),
                  ),
                  GoRoute(
                    path: 'health-profile',
                    builder: (context, state) =>
                        const HealthProfileWorkflowPage(),
                  ),
                  GoRoute(
                    path: 'practitioner/:id',
                    builder: (context, state) => PractitionerProfilePage(
                      practitionerId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _appointmentsTabNavKey,
            routes: [
              GoRoute(
                path: '/appointments',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: AppointmentsPage()),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => AppointmentDetailPage(
                      appointmentId: state.pathParameters['id']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'questionnaire',
                        builder: (context, state) =>
                            AppointmentQuestionnairePage(
                              appointmentId: state.pathParameters['id']!,
                            ),
                      ),
                      GoRoute(
                        path: 'instructions',
                        builder: (context, state) =>
                            AppointmentInstructionsPage(
                              appointmentId: state.pathParameters['id']!,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _messagesTabNavKey,
            routes: [
              GoRoute(
                path: '/messages',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: MessagesListPage()),
                routes: [
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => NewMessagePage(
                      initialSubject: state.uri.queryParameters['subject'],
                      initialMessage: state.uri.queryParameters['message'],
                    ),
                  ),
                  GoRoute(
                    path: 'c/:id',
                    builder: (context, state) => ConversationPage(
                      conversationId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _accountTabNavKey,
            routes: [
              GoRoute(
                path: '/account',
                redirect: (context, state) {
                  // Les sous-routes `/account/*` nécessitent une session.
                  // Le root `/account` affiche le login inline si besoin.
                  final isAuthed = _authBloc.state.isAuthenticated;
                  final path = state.uri.path;
                  if (!isAuthed && path != '/account') return '/account';
                  return null;
                },
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    key: const ValueKey('account'),
                    child: BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (prev, curr) =>
                          prev.isAuthenticated != curr.isAuthenticated,
                      builder: (context, authState) {
                        return authState.isAuthenticated
                            ? const AccountPage()
                            : const LoginPage(redirectTo: '/account');
                      },
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'profile',
                    builder: (context, state) => const ProfilePage(),
                  ),
                  GoRoute(
                    path: 'relatives',
                    builder: (context, state) => const RelativesPage(),
                  ),
                  GoRoute(
                    path: 'security',
                    builder: (context, state) => const SecurityPage(),
                    routes: [
                      GoRoute(
                        path: 'change-password',
                        builder: (context, state) => const ChangePasswordPage(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'payment',
                    builder: (context, state) => const PaymentPage(),
                  ),
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsPage(),
                  ),
                  GoRoute(
                    path: 'privacy',
                    builder: (context, state) => const PrivacyPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/health',
        builder: (context, state) => const HealthDashboardPage(),
        routes: [
          GoRoute(
            path: 'conditions',
            builder: (context, state) => const MedicalConditionsPage(),
          ),
          GoRoute(
            path: 'medications',
            builder: (context, state) => const MedicationsPage(),
          ),
          GoRoute(
            path: 'allergies',
            builder: (context, state) => const AllergiesPage(),
          ),
          GoRoute(
            path: 'vaccinations',
            builder: (context, state) => const VaccinationsPage(),
          ),
        ],
      ),
    ],
  );
}
