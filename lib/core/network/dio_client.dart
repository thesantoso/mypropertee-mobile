import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class DioClient {
  static Dio? _instance;
  
  static Dio getInstance({
    String? accessToken,
    Future<String?> Function()? tokenRefresher,
  }) {
    _instance ??= _createDio(
      accessToken: accessToken,
      tokenRefresher: tokenRefresher,
    );
    return _instance!;
  }

  static Dio create({
    String? accessToken,
    Future<String?> Function()? tokenRefresher,
  }) {
    return _createDio(
      accessToken: accessToken,
      tokenRefresher: tokenRefresher,
    );
  }

  static Dio _createDio({
    String? accessToken,
    Future<String?> Function()? tokenRefresher,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        sendTimeout: AppConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(
        accessToken: accessToken,
        tokenRefresher: tokenRefresher,
        dio: dio,
      ),
      ErrorInterceptor(),
      LoggingInterceptor(),
    ]);

    return dio;
  }

  static void reset() {
    _instance = null;
  }
}
