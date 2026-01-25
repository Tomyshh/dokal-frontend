import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/permissions/permissions_service.dart';
import 'core/network/dio_client.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/datasources/onboarding_local_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/repositories/onboarding_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/repositories/onboarding_repository.dart';
import 'features/auth/domain/usecases/complete_onboarding.dart';
import 'features/auth/domain/usecases/get_session.dart';
import 'features/auth/domain/usecases/get_onboarding_completed.dart';
import 'features/auth/domain/usecases/sign_in.dart';
import 'features/auth/domain/usecases/sign_out.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/login_bloc.dart';
import 'features/auth/presentation/bloc/onboarding_cubit.dart';
import 'features/auth/presentation/bloc/register_bloc.dart';
import 'features/messages/data/datasources/messages_demo_data_source.dart';
import 'features/messages/data/repositories/messages_repository_impl.dart';
import 'features/messages/domain/repositories/messages_repository.dart';
import 'features/messages/domain/usecases/get_conversation_messages.dart';
import 'features/messages/domain/usecases/get_conversations.dart';
import 'features/messages/domain/usecases/send_message.dart';
import 'features/messages/presentation/bloc/conversation_cubit.dart';
import 'features/messages/presentation/bloc/messages_cubit.dart';
import 'features/appointments/data/datasources/appointments_demo_data_source.dart';
import 'features/appointments/data/repositories/appointments_repository_impl.dart';
import 'features/appointments/domain/repositories/appointments_repository.dart';
import 'features/appointments/domain/usecases/cancel_appointment.dart';
import 'features/appointments/domain/usecases/get_appointment_detail.dart';
import 'features/appointments/domain/usecases/get_past_appointments.dart';
import 'features/appointments/domain/usecases/get_upcoming_appointments.dart';
import 'features/appointments/presentation/bloc/appointment_detail_cubit.dart';
import 'features/appointments/presentation/bloc/appointments_cubit.dart';
import 'features/account/data/datasources/settings_local_data_source.dart';
import 'features/account/data/repositories/settings_repository_impl.dart';
import 'features/account/domain/repositories/settings_repository.dart';
import 'features/account/domain/usecases/get_settings.dart';
import 'features/account/domain/usecases/save_settings.dart';
import 'features/account/presentation/bloc/settings_cubit.dart';
import 'features/health/data/datasources/documents_demo_data_source.dart';
import 'features/health/data/repositories/documents_repository_impl.dart';
import 'features/health/domain/repositories/documents_repository.dart';
import 'features/health/domain/usecases/add_demo_document.dart';
import 'features/health/domain/usecases/get_documents.dart';
import 'features/health/presentation/bloc/documents_cubit.dart';
import 'features/search/data/datasources/search_demo_data_source.dart';
import 'features/search/data/repositories/search_repository_impl.dart';
import 'features/search/domain/repositories/search_repository.dart';
import 'features/search/domain/usecases/search_practitioners.dart';
import 'features/search/presentation/bloc/search_cubit.dart';
import 'features/practitioner/data/datasources/practitioner_demo_data_source.dart';
import 'features/practitioner/data/repositories/practitioner_repository_impl.dart';
import 'features/practitioner/domain/repositories/practitioner_repository.dart';
import 'features/practitioner/domain/usecases/get_practitioner_profile.dart';
import 'features/practitioner/presentation/bloc/practitioner_cubit.dart';
import 'features/health/data/datasources/health_demo_data_source.dart';
import 'features/health/data/repositories/health_repository_impl.dart';
import 'features/health/domain/repositories/health_repository.dart';
import 'features/health/domain/usecases/add_health_item_demo.dart';
import 'features/health/domain/usecases/get_health_list.dart';
import 'features/health/presentation/bloc/health_list_cubit.dart';
import 'features/account/data/datasources/account_demo_data_source.dart';
import 'features/account/data/repositories/account_repository_impl.dart';
import 'features/account/domain/repositories/account_repository.dart';
import 'features/account/domain/usecases/add_payment_method_demo.dart';
import 'features/account/domain/usecases/add_relative_demo.dart';
import 'features/account/domain/usecases/get_payment_methods.dart';
import 'features/account/domain/usecases/get_profile.dart';
import 'features/account/domain/usecases/get_relatives.dart';
import 'features/account/domain/usecases/request_password_change_demo.dart';
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
import 'features/booking/data/datasources/booking_demo_data_source.dart';
import 'features/booking/data/repositories/booking_repository_impl.dart';
import 'features/booking/domain/repositories/booking_repository.dart';
import 'features/booking/domain/usecases/confirm_booking.dart';
import 'features/booking/presentation/bloc/booking_confirm_cubit.dart';
import 'features/booking/presentation/bloc/booking_patients_cubit.dart';

final sl = GetIt.instance;

void configureDependencies() {
  // External
  // IMPORTANT: on le veut prêt dès le démarrage (sinon `sl<SharedPreferences>()` peut crasher).
  sl.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());

  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<DioClient>(() => DioClient(sl<Dio>()));

  // Permissions
  sl.registerLazySingleton(() => PermissionsService());

  // Supabase
  // Fournir les valeurs via soit:
  // - `flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...`
  // - ou un fichier `.env.local` (via `--dart-define-from-file=.env.local`)
  // On supporte aussi les clés style Expo (`EXPO_PUBLIC_*`) pour éviter les confusions.
  final supabaseUrlDefine =
      const String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  final supabaseUrlExpo =
      const String.fromEnvironment('EXPO_PUBLIC_SUPABASE_URL', defaultValue: '');
  final supabaseAnonKeyDefine =
      const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
  final supabaseKeyDefine =
      const String.fromEnvironment('SUPABASE_KEY', defaultValue: '');
  final supabaseKeyExpo =
      const String.fromEnvironment('EXPO_PUBLIC_SUPABASE_KEY', defaultValue: '');

  final supabaseUrl =
      supabaseUrlDefine.isNotEmpty ? supabaseUrlDefine : supabaseUrlExpo;
  final supabaseAnonKey = supabaseAnonKeyDefine.isNotEmpty
      ? supabaseAnonKeyDefine
      : (supabaseKeyDefine.isNotEmpty ? supabaseKeyDefine : supabaseKeyExpo);

  sl.registerSingletonAsync<SupabaseClient>(() async {
    // Si non configuré, on démarre quand même l’app (les calls distants échoueront).
    final url = supabaseUrl.isEmpty ? 'http://localhost:54321' : supabaseUrl;
    final key = supabaseAnonKey.isEmpty ? 'anon' : supabaseAnonKey;
    return SupabaseClient(url, key);
  });

  // Auth
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
  sl.registerLazySingleton(() => GetOnboardingCompleted(sl<OnboardingRepository>()));
  sl.registerLazySingleton(() => CompleteOnboarding(sl<OnboardingRepository>()));

  sl.registerLazySingleton(
    () => AuthBloc(
      getSession: sl<GetSession>(),
      signOut: sl<SignOut>(),
    ),
  );

  sl.registerFactory(() => LoginBloc(signIn: sl<SignIn>()));
  sl.registerFactory(() => RegisterBloc(signUp: sl<SignUp>()));
  sl.registerFactory(
    () => OnboardingCubit(
      getOnboardingCompleted: sl<GetOnboardingCompleted>(),
      completeOnboarding: sl<CompleteOnboarding>(),
    ),
  );

  // Messages (démo)
  sl.registerLazySingleton<MessagesDemoDataSource>(
    () => MessagesDemoDataSourceImpl(),
  );
  sl.registerLazySingleton<MessagesRepository>(
    () => MessagesRepositoryImpl(demo: sl<MessagesDemoDataSource>()),
  );
  sl.registerLazySingleton(() => GetConversations(sl<MessagesRepository>()));
  sl.registerLazySingleton(
    () => GetConversationMessages(sl<MessagesRepository>()),
  );
  sl.registerLazySingleton(() => SendMessage(sl<MessagesRepository>()));

  sl.registerFactory(() => MessagesCubit(getConversations: sl<GetConversations>()));
  sl.registerFactoryParam<ConversationCubit, String, void>(
    (conversationId, _) => ConversationCubit(
      getConversationMessages: sl<GetConversationMessages>(),
      sendMessage: sl<SendMessage>(),
      conversationId: conversationId,
    ),
  );

  // Appointments (démo)
  sl.registerLazySingleton<AppointmentsDemoDataSource>(
    () => AppointmentsDemoDataSourceImpl(),
  );
  sl.registerLazySingleton<AppointmentsRepository>(
    () => AppointmentsRepositoryImpl(demo: sl<AppointmentsDemoDataSource>()),
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

  // Account / Settings (local)
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(prefs: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(local: sl<SettingsLocalDataSource>()),
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

  // Health / Documents (démo)
  sl.registerLazySingleton<DocumentsDemoDataSource>(
    () => DocumentsDemoDataSourceImpl(),
  );
  sl.registerLazySingleton<DocumentsRepository>(
    () => DocumentsRepositoryImpl(demo: sl<DocumentsDemoDataSource>()),
  );
  sl.registerLazySingleton(() => GetDocuments(sl<DocumentsRepository>()));
  sl.registerLazySingleton(() => AddDemoDocument(sl<DocumentsRepository>()));
  sl.registerFactory(
    () => DocumentsCubit(
      getDocuments: sl<GetDocuments>(),
      addDemoDocument: sl<AddDemoDocument>(),
    )..load(),
  );

  // Search (démo)
  sl.registerLazySingleton<SearchDemoDataSource>(() => SearchDemoDataSourceImpl());
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(demo: sl<SearchDemoDataSource>()),
  );
  sl.registerLazySingleton(() => SearchPractitioners(sl<SearchRepository>()));
  sl.registerFactory(() => SearchCubit(searchPractitioners: sl<SearchPractitioners>())..search());

  // Practitioner (démo)
  sl.registerLazySingleton<PractitionerDemoDataSource>(
    () => PractitionerDemoDataSourceImpl(),
  );
  sl.registerLazySingleton<PractitionerRepository>(
    () => PractitionerRepositoryImpl(demo: sl<PractitionerDemoDataSource>()),
  );
  sl.registerLazySingleton(
    () => GetPractitionerProfile(sl<PractitionerRepository>()),
  );
  sl.registerFactoryParam<PractitionerCubit, String, void>(
    (practitionerId, _) => PractitionerCubit(
      getPractitionerProfile: sl<GetPractitionerProfile>(),
      practitionerId: practitionerId,
    )..load(),
  );

  // Health lists (démo)
  sl.registerLazySingleton<HealthDemoDataSource>(() => HealthDemoDataSourceImpl());
  sl.registerLazySingleton<HealthRepository>(
    () => HealthRepositoryImpl(demo: sl<HealthDemoDataSource>()),
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

  // Account (démo) : profil / proches / paiement / sécurité
  sl.registerLazySingleton<AccountDemoDataSource>(
    () => AccountDemoDataSourceImpl(prefs: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(demo: sl<AccountDemoDataSource>()),
  );
  sl.registerLazySingleton(() => GetProfile(sl<AccountRepository>()));
  sl.registerLazySingleton(() => GetRelatives(sl<AccountRepository>()));
  sl.registerLazySingleton(() => AddRelativeDemo(sl<AccountRepository>()));
  sl.registerLazySingleton(() => GetPaymentMethods(sl<AccountRepository>()));
  sl.registerLazySingleton(() => AddPaymentMethodDemo(sl<AccountRepository>()));
  sl.registerLazySingleton(() => RequestPasswordChangeDemo(sl<AccountRepository>()));

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

  // Home (local)
  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(prefs: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(local: sl<HomeLocalDataSource>()),
  );
  sl.registerLazySingleton(() => GetHomeGreetingName(sl<HomeRepository>()));
  sl.registerLazySingleton(() => GetHomeHistoryEnabled(sl<HomeRepository>()));
  sl.registerLazySingleton(() => EnableHomeHistory(sl<HomeRepository>()));
  sl.registerFactory(
    () => HomeCubit(
      getGreetingName: sl<GetHomeGreetingName>(),
      getHistoryEnabled: sl<GetHomeHistoryEnabled>(),
      enableHistory: sl<EnableHomeHistory>(),
    )..load(),
  );

  // Booking confirm (démo)
  sl.registerLazySingleton<BookingDemoDataSource>(() => BookingDemoDataSourceImpl());
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(demo: sl<BookingDemoDataSource>()),
  );
  sl.registerLazySingleton(() => ConfirmBooking(sl<BookingRepository>()));
  sl.registerFactory(() => BookingConfirmCubit(confirmBooking: sl<ConfirmBooking>()));
  sl.registerFactory(
    () => BookingPatientsCubit(
      getProfile: sl<GetProfile>(),
      getRelatives: sl<GetRelatives>(),
      addRelativeDemo: sl<AddRelativeDemo>(),
    )..load(),
  );
}

