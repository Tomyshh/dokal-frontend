import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration d'environnement chargée depuis .env.prod au runtime.
/// Utilisée par injection_container, ApiClient, etc.
class EnvConfig {
  EnvConfig._();

  static String _get(String key, {String defaultValue = ''}) {
    final fromDotenv = dotenv.env[key];
    if (fromDotenv != null && fromDotenv.isNotEmpty) return fromDotenv;
    return defaultValue;
  }

  static String get supabaseUrl => _get('EXPO_PUBLIC_SUPABASE_URL',
      defaultValue: _get('SUPABASE_URL'));

  static String get supabaseAnonKey => _get('EXPO_PUBLIC_SUPABASE_KEY',
      defaultValue: _get('SUPABASE_ANON_KEY', defaultValue: _get('SUPABASE_KEY')));

  static String get backendUrl =>
      _get('BACKEND_URL', defaultValue: 'https://dokal-backend.onrender.com');

  static String get googleWebClientId => _get('GOOGLE_WEB_CLIENT_ID',
      defaultValue: _get('EXPO_PUBLIC_GOOGLE_WEB_CLIENT_ID'));

  static String get googleIosClientId => _get('GOOGLE_IOS_CLIENT_ID',
      defaultValue: _get('EXPO_PUBLIC_GOOGLE_IOS_CLIENT_ID'));

  static String get oneSignalAppId => _get('ONESIGNAL_APP_ID');
}
