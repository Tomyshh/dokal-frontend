import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../errors/exceptions.dart';

/// Centralised HTTP client for Dokal backend API calls.
///
/// - Injects the Supabase JWT in every request (`Authorization: Bearer <token>`).
/// - Converts backend error shapes (`{ error: { code, message } }`) into
///   [ServerException].
class ApiClient {
  ApiClient({
    required Dio dio,
    required Future<SupabaseClient> supabaseClientFuture,
  })  : _dio = dio,
        _supabaseClientFuture = supabaseClientFuture {
    // Read BACKEND_URL from dart-define / .env.prod
    const backendUrl = String.fromEnvironment(
      'BACKEND_URL',
      defaultValue: 'https://dokal-backend.onrender.com',
    );
    if (backendUrl.isEmpty) {
      throw StateError(
        'BACKEND_URL is not configured. '
        'Pass it via --dart-define=BACKEND_URL=... or --dart-define-from-file=.env.prod',
      );
    }

    _dio.options = BaseOptions(
      baseUrl: backendUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final client = await _supabaseClientFuture;
          final token = client.auth.currentSession?.accessToken;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  final Dio _dio;
  final Future<SupabaseClient> _supabaseClientFuture;

  // ---------------------------------------------------------------------------
  // Convenience wrappers
  // ---------------------------------------------------------------------------

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> post(
    String path, {
    Object? data,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> patch(
    String path, {
    Object? data,
  }) async {
    try {
      final response = await _dio.patch(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> put(
    String path, {
    Object? data,
  }) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> delete(String path, {Object? data}) async {
    try {
      await _dio.delete(path, data: data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ---------------------------------------------------------------------------
  // Error handling
  // ---------------------------------------------------------------------------

  ServerException _handleDioError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        final message = error['message'] as String? ?? 'Unknown error';
        return ServerException(message);
      }
    }
    return ServerException(e.message ?? 'Network error');
  }
}
