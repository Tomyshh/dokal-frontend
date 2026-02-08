import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/permissions/permissions_service.dart';
import 'core/network/api_client.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/datasources/onboarding_local_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/repositories/onboarding_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/repositories/onboarding_repository.dart';
import 'features/auth/domain/usecases/complete_onboarding.dart';
import 'features/auth/domain/usecases/get_session.dart';
import 'features/auth/domain/usecases/get_onboarding_completed.dart';
import 'features/auth/domain/usecases/request_password_reset.dart';
import 'features/auth/domain/usecases/resend_signup_confirmation_email.dart';
import 'features/auth/domain/usecases/sign_in.dart';
import 'features/auth/domain/usecases/sign_out.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/forgot_password_cubit.dart';
import 'features/auth/presentation/bloc/login_bloc.dart';
import 'features/auth/presentation/bloc/onboarding_cubit.dart';
import 'features/auth/presentation/bloc/register_bloc.dart';
import 'features/auth/presentation/bloc/verify_email_cubit.dart';
import 'features/messages/data/datasources/messages_remote_data_source.dart';
import 'features/messages/data/repositories/messages_repository_impl.dart';
import 'features/messages/domain/repositories/messages_repository.dart';
import 'features/messages/domain/usecases/get_conversation_messages.dart';
import 'features/messages/domain/usecases/get_conversations.dart';
import 'features/messages/domain/usecases/send_message.dart';
import 'features/messages/presentation/bloc/conversation_cubit.dart';
import 'features/messages/presentation/bloc/messages_cubit.dart';
import 'features/appointments/data/datasources/appointments_remote_data_source.dart';
import 'features/appointments/data/repositories/appointments_repository_impl.dart';
import 'features/appointments/domain/repositories/appointments_repository.dart';
import 'features/appointments/domain/usecases/cancel_appointment.dart';
import 'features/appointments/domain/usecases/get_appointment_detail.dart';
import 'features/appointments/domain/usecases/get_past_appointments.dart';
import 'features/appointments/domain/usecases/get_upcoming_appointments.dart';
import 'features/appointments/presentation/bloc/appointment_detail_cubit.dart';
import 'features/appointments/presentation/bloc/appointments_cubit.dart';
import 'features/account/data/datasources/settings_remote_data_source.dart';
import 'features/account/data/repositories/settings_repository_impl.dart';
import 'features/account/domain/repositories/settings_repository.dart';
import 'features/account/domain/usecases/get_settings.dart';
import 'features/account/domain/usecases/save_settings.dart';
import 'features/account/presentation/bloc/settings_cubit.dart';
import 'features/search/data/datasources/search_remote_data_source.dart';
import 'features/search/data/repositories/search_repository_impl.dart';
import 'features/search/domain/repositories/search_repository.dart';
import 'features/search/domain/usecases/search_practitioners.dart';
import 'features/search/presentation/bloc/search_cubit.dart';
import 'features/practitioner/data/datasources/practitioner_remote_data_source.dart';
import 'features/practitioner/data/repositories/practitioner_repository_impl.dart';
import 'features/practitioner/domain/repositories/practitioner_repository.dart';
import 'features/practitioner/domain/usecases/get_practitioner_profile.dart';
import 'features/practitioner/domain/usecases/get_practitioner_slots.dart';
import 'features/practitioner/domain/usecases/get_practitioner_reviews.dart';
import 'features/practitioner/presentation/bloc/practitioner_cubit.dart';
import 'features/health/data/datasources/health_remote_data_source.dart';
import 'features/health/data/datasources/health_profile_remote_data_source.dart';
import 'features/health/data/repositories/health_repository_impl.dart';
import 'features/health/data/repositories/health_profile_repository_impl.dart';
import 'features/health/domain/repositories/health_repository.dart';
import 'features/health/domain/repositories/health_profile_repository.dart';
import 'features/health/domain/usecases/add_health_item_demo.dart';
import 'features/health/domain/usecases/get_health_list.dart';
import 'features/health/domain/usecases/get_health_profile.dart';
import 'features/health/domain/usecases/save_health_profile.dart';
import 'features/health/presentation/bloc/health_list_cubit.dart';
import 'features/health/presentation/bloc/health_profile_cubit.dart';
import 'features/account/data/datasources/account_remote_data_source.dart';
import 'features/account/data/repositories/account_repository_impl.dart';
import 'features/account/domain/repositories/account_repository.dart';
import 'features/account/domain/usecases/add_payment_method_demo.dart';
import 'features/account/domain/usecases/add_relative_demo.dart';
import 'features/account/domain/usecases/delete_payment_method.dart';
import 'features/account/domain/usecases/get_payment_methods.dart';
import 'features/account/domain/usecases/get_profile.dart';
import 'features/account/domain/usecases/get_relatives.dart';
import 'features/account/domain/usecases/request_password_change_demo.dart';
import 'features/account/domain/usecases/set_default_payment_method.dart';
import 'features/account/domain/usecases/update_profile.dart';
import 'features/account/domain/usecases/upload_avatar.dart';
import 'features/account/presentation/bloc/change_password_cubit.dart';
import 'features/account/presentation/bloc/payment_cubit.dart';
import 'features/account/presentation/bloc/profile_cubit.dart';
import 'features/account/presentation/bloc/relatives_cubit.dart';
import 'features/home/data/datasources/home_local_data_source.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/enable_home_history.dart';
import 'features/home/domain/usecases/get_home_greeting_name.dart';
import 'features/home/domain/usecases/get_home_history_enabled.dart';
import 'features/home/presentation/bloc/home_cubit.dart';
import 'features/booking/data/datasources/booking_remote_data_source.dart';
import 'features/booking/data/repositories/booking_repository_impl.dart';
import 'features/booking/domain/repositories/booking_repository.dart';
import 'features/booking/domain/usecases/confirm_booking.dart';
import 'features/booking/presentation/bloc/booking_confirm_cubit.dart';
import 'features/booking/presentation/bloc/booking_patients_cubit.dart';
import 'features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'features/notifications/data/repositories/notifications_repository_impl.dart';
import 'features/notifications/domain/repositories/notifications_repository.dart';
import 'features/notifications/domain/usecases/get_notifications.dart';
import 'features/notifications/domain/usecases/get_unread_count.dart';
import 'features/notifications/domain/usecases/mark_all_read.dart';
import 'features/notifications/domain/usecases/mark_notification_read.dart';
import 'features/notifications/domain/usecases/register_push_token.dart';
import 'features/notifications/domain/usecases/remove_push_token.dart';
import 'features/notifications/presentation/bloc/notifications_cubit.dart';
import 'features/reviews/data/datasources/reviews_remote_data_source.dart';
import 'features/reviews/data/repositories/reviews_repository_impl.dart';
import 'features/reviews/domain/repositories/reviews_repository.dart';
import 'features/reviews/domain/usecases/create_review.dart';
import 'features/reviews/presentation/bloc/reviews_cubit.dart';

final sl = GetIt.instance;

void configureDependencies() {
  // External
  sl.registerSingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );

  // Permissions
  sl.registerLazySingleton(() => PermissionsService());

  // Supabase
  const supabaseUrlDefine = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  const supabaseUrlExpo = String.fromEnvironment(
    'EXPO_PUBLIC_SUPABASE_URL',
    defaultValue: '',
  );
  const supabaseAnonKeyDefine = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );
  const supabaseKeyDefine = String.fromEnvironment(
    'SUPABASE_KEY',
    defaultValue: '',
  );
  const supabaseKeyExpo = String.fromEnvironment(
    'EXPO_PUBLIC_SUPABASE_KEY',
    defaultValue: '',
  );

  final supabaseUrl =
      supabaseUrlDefine.isNotEmpty ? supabaseUrlDefine : supabaseUrlExpo;
  final supabaseAnonKey = supabaseAnonKeyDefine.isNotEmpty
      ? supabaseAnonKeyDefine
      : (supabaseKeyDefine.isNotEmpty ? supabaseKeyDefine : supabaseKeyExpo);

  if (kDebugMode) {
    debugPrint('[Dokal] Supabase URL: $supabaseUrl');
    debugPrint('[Dokal] Supabase key present: ${supabaseAnonKey.isNotEmpty}');
  }

  sl.registerSingletonAsync<SupabaseClient>(() async {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw StateError(
        "Supabase n'est pas configuré. Ajoutez `EXPO_PUBLIC_SUPABASE_URL` et "
        "`EXPO_PUBLIC_SUPABASE_KEY` dans `.env.prod` puis lancez l'app avec "
        "`--dart-define-from-file=.env.prod`.",
      );
    }

    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

    return Supabase.instance.client;
  });

  // ---------------------------------------------------------------------------
  // API Client (backend REST)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      dio: Dio(),
      supabaseClientFuture: sl.getAsync<SupabaseClient>(),
    ),
  );

  // ---------------------------------------------------------------------------
  // Auth (Supabase Auth – remains as-is)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      supabaseClientFuture: sl.getAsync<SupabaseClient>(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: sl<AuthRemoteDataSource>()),
  );

  // Onboarding (local)
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(prefs: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(local: sl<OnboardingLocalDataSource>()),
  );

  sl.registerLazySingleton(() => SignIn(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignUp(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignOut(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetSession(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RequestPasswordReset(sl<AuthRepository>()));
  sl.registerLazySingleton(
    () => ResendSignupConfirmationEmail(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => GetOnboardingCompleted(sl<OnboardingRepository>()),
  );
  sl.registerLazySingleton(
    () => CompleteOnboarding(sl<OnboardingRepository>()),
  );

  sl.registerLazySingleton(
    () => AuthBloc(getSession: sl<GetSession>(), signOut: sl<SignOut>()),
  );

  sl.registerFactory(() => LoginBloc(signIn: sl<SignIn>()));
  sl.registerFactory(() => RegisterBloc(signUp: sl<SignUp>()));
  sl.registerFactory(
    () => ForgotPasswordCubit(requestPasswordReset: sl<RequestPasswordReset>()),
  );
  sl.registerFactory(
    () => VerifyEmailCubit(resend: sl<ResendSignupConfirmationEmail>()),
  );
  sl.registerFactory(
    () => OnboardingCubit(
      getOnboardingCompleted: sl<GetOnboardingCompleted>(),
      completeOnboarding: sl<CompleteOnboarding>(),
    ),
  );

  // ---------------------------------------------------------------------------
  // Messages (remote)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<MessagesRemoteDataSourceImpl>(
    () => MessagesRemoteDataSourceImpl(
      api: sl<ApiClient>(),
      currentUserId: () {
        try {
          return Supabase.instance.client.auth.currentUser?.id ?? '';
        } catch (_) {
          return '';
        }
      },
    ),
  );
  sl.registerLazySingleton<MessagesRepository>(
    () => MessagesRepositoryImpl(remote: sl<MessagesRemoteDataSourceImpl>()),
  );
  sl.registerLazySingleton(() => GetConversations(sl<MessagesRepository>()));
  sl.registerLazySingleton(
    () => GetConversationMessages(sl<MessagesRepository>()),
  );
  sl.registerLazySingleton(() => SendMessage(sl<MessagesRepository>()));

  sl.registerFactory(
    () => MessagesCubit(getConversations: sl<GetConversations>()),
  );
  sl.registerFactoryParam<ConversationCubit, String, void>(
    (conversationId, _) => ConversationCubit(
      getConversationMessages: sl<GetConversationMessages>(),
      sendMessage: sl<SendMessage>(),
      conversationId: conversationId,
    ),
  );

  // ---------------------------------------------------------------------------
  // Appointments (remote)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<AppointmentsRemoteDataSourceImpl>(
    () => AppointmentsRemoteDataSourceImpl(api: sl<ApiClient>()),
  );
  sl.registerLazySingleton<AppointmentsRepository>(
    () => AppointmentsRepositoryImpl(
      remote: sl<AppointmentsRemoteDataSourceImpl>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetUpcomingAppointments(sl<AppointmentsRepository>()),
  );
  sl.registerLazySingleton(
    () => GetPastAppointments(sl<AppointmentsRepository>()),
  );
  sl.registerLazySingleton(
    () => GetAppointmentDetail(sl<AppointmentsRepository>()),
  );
  sl.registerLazySingleton(
    () => CancelAppointment(sl<AppointmentsRepository>()),
  );

  sl.registerFactory(
    () => AppointmentsCubit(
      getUpcoming: sl<GetUpcomingAppointments>(),
      getPast: sl<GetPastAppointments>(),
    ),
  );
  sl.registerFactoryParam<AppointmentDetailCubit, String, void>(
    (appointmentId, _) => AppointmentDetailCubit(
      getAppointmentDetail: sl<GetAppointmentDetail>(),
      cancelAppointment: sl<CancelAppointment>(),
      appointmentId: appointmentId,
    ),
  );

  // ---------------------------------------------------------------------------
  // Account / Settings (remote)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<SettingsRemoteDataSourceImpl>(
    () => SettingsRemoteDataSourceImpl(api: sl<ApiClient>()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(remote: sl<SettingsRemoteDataSourceImpl>()),
  );
  sl.registerLazySingleton(() => GetSettings(sl<SettingsRepository>()));
  sl.registerLazySingleton(() => SaveSettings(sl<SettingsRepository>()));
  sl.registerFactory(
    () => SettingsCubit(
      getSettings: sl<GetSettings>(),
      saveSettings: sl<SaveSettings>(),
      permissionsService: sl<PermissionsService>(),
    )..load(),
  );

  // ---------------------------------------------------------------------------
  // Search (remote)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<SearchRemoteDataSourceImpl>(
    () => SearchRemoteDataSourceImpl(api: sl<ApiClient>()),
  );
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remote: sl<SearchRemoteDataSourceImpl>()),
  );
  sl.registerLazySingleton(() => SearchPractitioners(sl<SearchRepository>()));
  sl.registerFactory(
    () => SearchCubit(searchPractitioners: sl<SearchPractitioners>())..search(),
  );

  // ---------------------------------------------------------------------------
  // Practitioner (remote)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<PractitionerRemoteDataSourceImpl>(
    () => PractitionerRemoteDataSourceImpl(api: sl<ApiClient>()),
  );
  sl.registerLazySingleton<PractitionerRepository>(
    () => PractitionerRepositoryImpl(
      remote: sl<PractitionerRemoteDataSourceImpl>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetPractitionerProfile(sl<PractitionerRepository>()),
  );
  sl.registerLazySingleton(
    () => GetPractitionerSlots(sl<PractitionerRepository>()),
  );
  sl.registerLazySingleton(
    () => GetPractitionerReviews(sl<PractitionerRepository>()),
  );
  sl.registerFactoryParam<PractitionerCubit, String, void>(
    (practitionerId, _) => PractitionerCubit(
      getPractitionerProfile: sl<GetPractitionerProfile>(),
      practitionerId: practitionerId,
    )..load(),
  );

  // ---------------------------------------------------------------------------
  // Health lists (remote)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<HealthRemoteDataSourceImpl>(
    () => HealthRemoteDataSourceImpl(api: sl<ApiClient>()),
  );
  sl.registerLazySingleton<HealthRepository>(
    () => HealthRepositoryImpl(remote: sl<HealthRemoteDataSourceImpl>()),
  );
  sl.registerLazySingleton(() => GetHealthList(sl<HealthRepository>()));
  sl.registerLazySingleton(() => AddHealthItemDemo(sl<HealthRepository>()));
  sl.registerFactoryParam<HealthListCubit, HealthListType, void>(
    (type, _) => HealthListCubit(
      type: type,
      getHealthList: sl<GetHealthList>(),
      addHealthItemDemo: sl<AddHealthItemDemo>(),
    )..load(),
  );

  // ---------------------------------------------------------------------------
  // Health profile (remote)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<HealthProfileRemoteDataSourceImpl>(
    () => HealthProfileRemoteDataSourceImpl(api: sl<ApiClient>()),
  );
  sl.registerLazySingleton<HealthProfileRepository>(
    () => HealthProfileRepositoryImpl(
      remote: sl<HealthProfileRemoteDataSourceImpl>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetHealthProfile(sl<HealthProfileRepository>()),
  );
  sl.registerLazySingleton(
    () => SaveHealthProfile(sl<HealthProfileRepository>()),
  );
  sl.registerFactory(
    () => HealthProfileCubit(
      getHealthProfile: sl<GetHealthProfile>(),
      saveHealthProfile: sl<SaveHealthProfile>(),
    ),
  );

  // ---------------------------------------------------------------------------
  // Account (remote) : profil / proches / paiement / securite
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<AccountRemoteDataSourceImpl>(
    () => AccountRemoteDataSourceImpl(api: sl<ApiClient>()),
  );
  sl.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(remote: sl<AccountRemoteDataSourceImpl>()),
  );
  sl.registerLazySingleton(() => GetProfile(sl<AccountRepository>()));
  sl.registerLazySingleton(() => GetRelatives(sl<AccountRepository>()));
  sl.registerLazySingleton(() => AddRelativeDemo(sl<AccountRepository>()));
  sl.registerLazySingleton(() => GetPaymentMethods(sl<AccountRepository>()));
  sl.registerLazySingleton(() => AddPaymentMethodDemo(sl<AccountRepository>()));
  sl.registerLazySingleton(
    () => RequestPasswordChangeDemo(sl<AccountRepository>()),
  );
  sl.registerLazySingleton(() => UpdateProfile(sl<AccountRepository>()));
  sl.registerLazySingleton(() => UploadAvatar(sl<AccountRepository>()));
  sl.registerLazySingleton(() => DeletePaymentMethod(sl<AccountRepository>()));
  sl.registerLazySingleton(
    () => SetDefaultPaymentMethod(sl<AccountRepository>()),
  );

  sl.registerFactory(() => ProfileCubit(getProfile: sl<GetProfile>())..load());
  sl.registerFactory(
    () => RelativesCubit(
      getRelatives: sl<GetRelatives>(),
      addRelativeDemo: sl<AddRelativeDemo>(),
    )..load(),
  );
  sl.registerFactory(
    () => PaymentCubit(
      getPaymentMethods: sl<GetPaymentMethods>(),
      addPaymentMethodDemo: sl<AddPaymentMethodDemo>(),
    )..load(),
  );
  sl.registerFactory(
    () => ChangePasswordCubit(
      requestPasswordChangeDemo: sl<RequestPasswordChangeDemo>(),
    ),
  );

  // ---------------------------------------------------------------------------
  // Home (local + API)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(prefs: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      local: sl<HomeLocalDataSource>(),
      api: sl<ApiClient>(),
    ),
  );
  sl.registerLazySingleton(() => GetHomeGreetingName(sl<HomeRepository>()));
  sl.registerLazySingleton(() => GetHomeHistoryEnabled(sl<HomeRepository>()));
  sl.registerLazySingleton(() => EnableHomeHistory(sl<HomeRepository>()));
  sl.registerFactory(
    () => HomeCubit(
      getGreetingName: sl<GetHomeGreetingName>(),
      getHistoryEnabled: sl<GetHomeHistoryEnabled>(),
      enableHistory: sl<EnableHomeHistory>(),
      getUpcomingAppointments: sl<GetUpcomingAppointments>(),
      getPastAppointments: sl<GetPastAppointments>(),
      getConversations: sl<GetConversations>(),
    )..load(),
  );

  // ---------------------------------------------------------------------------
  // Booking (remote)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<BookingRemoteDataSourceImpl>(
    () => BookingRemoteDataSourceImpl(api: sl<ApiClient>()),
  );
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(remote: sl<BookingRemoteDataSourceImpl>()),
  );
  sl.registerLazySingleton(() => ConfirmBooking(sl<BookingRepository>()));
  sl.registerFactory(
    () => BookingConfirmCubit(confirmBooking: sl<ConfirmBooking>()),
  );
  sl.registerFactory(
    () => BookingPatientsCubit(
      getProfile: sl<GetProfile>(),
      getRelatives: sl<GetRelatives>(),
      addRelativeDemo: sl<AddRelativeDemo>(),
    )..load(),
  );

  // ---------------------------------------------------------------------------
  // Notifications (remote)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(api: sl<ApiClient>()),
  );
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(
      remote: sl<NotificationsRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetNotifications(sl<NotificationsRepository>()),
  );
  sl.registerLazySingleton(
    () => GetUnreadCount(sl<NotificationsRepository>()),
  );
  sl.registerLazySingleton(
    () => MarkNotificationRead(sl<NotificationsRepository>()),
  );
  sl.registerLazySingleton(
    () => MarkAllRead(sl<NotificationsRepository>()),
  );
  sl.registerLazySingleton(
    () => RegisterPushToken(sl<NotificationsRepository>()),
  );
  sl.registerLazySingleton(
    () => RemovePushToken(sl<NotificationsRepository>()),
  );
  sl.registerFactory(
    () => NotificationsCubit(
      getNotifications: sl<GetNotifications>(),
      getUnreadCount: sl<GetUnreadCount>(),
      markNotificationRead: sl<MarkNotificationRead>(),
      markAllRead: sl<MarkAllRead>(),
      registerPushToken: sl<RegisterPushToken>(),
      removePushToken: sl<RemovePushToken>(),
    ),
  );

  // ---------------------------------------------------------------------------
  // Reviews (remote)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<ReviewsRemoteDataSourceImpl>(
    () => ReviewsRemoteDataSourceImpl(api: sl<ApiClient>()),
  );
  sl.registerLazySingleton<ReviewsRepository>(
    () => ReviewsRepositoryImpl(remote: sl<ReviewsRemoteDataSourceImpl>()),
  );
  sl.registerLazySingleton(() => CreateReview(sl<ReviewsRepository>()));
  sl.registerFactory(
    () => ReviewsCubit(createReview: sl<CreateReview>()),
  );
}
