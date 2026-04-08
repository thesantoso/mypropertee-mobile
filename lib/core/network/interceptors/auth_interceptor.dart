import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final String? accessToken;
  final Future<String?> Function()? tokenRefresher;
  final Dio dio;

  AuthInterceptor({
    this.accessToken,
    this.tokenRefresher,
    required this.dio,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && tokenRefresher != null) {
      try {
        final newToken = await tokenRefresher!();
        if (newToken != null) {
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final response = await dio.fetch(err.requestOptions);
          handler.resolve(response);
          return;
        }
      } catch (_) {
        // Token refresh failed, propagate original error
      }
    }
    handler.next(err);
  }
}
