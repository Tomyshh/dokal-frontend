import 'package:dio/dio.dart';

class DioClient {
  DioClient(this._dio) {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    );
  }

  final Dio _dio;

  Dio get raw => _dio;
}
