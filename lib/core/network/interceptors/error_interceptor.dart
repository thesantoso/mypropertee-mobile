import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const AppException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'AppException($statusCode): $message';
}

class NetworkException extends AppException {
  const NetworkException({required super.message}) : super(statusCode: 0);
}

class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode, super.data});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({super.message = 'Unauthorized'})
      : super(statusCode: 401);
}

class ForbiddenException extends AppException {
  const ForbiddenException({super.message = 'Forbidden'})
      : super(statusCode: 403);
}

class NotFoundException extends AppException {
  const NotFoundException({super.message = 'Not Found'})
      : super(statusCode: 404);
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _mapError(err);
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: exception,
        message: exception.message,
      ),
    );
  }

  AppException _mapError(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Connection timed out. Please check your internet connection.',
        );
      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'No internet connection. Please try again.',
        );
      case DioExceptionType.badResponse:
        return _mapResponseError(err);
      case DioExceptionType.cancel:
        return const AppException(message: 'Request was cancelled.');
      default:
        return AppException(
          message: err.message ?? 'An unexpected error occurred.',
        );
    }
  }

  AppException _mapResponseError(DioException err) {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;
    final message = _extractMessage(data) ?? 'An error occurred.';

    switch (statusCode) {
      case 400:
        return AppException(message: message, statusCode: 400, data: data);
      case 401:
        return UnauthorizedException(message: message);
      case 403:
        return ForbiddenException(message: message);
      case 404:
        return NotFoundException(message: message);
      case 422:
        return AppException(
          message: message,
          statusCode: 422,
          data: data,
        );
      case 500:
      case 502:
      case 503:
        return ServerException(
          message: 'Server error. Please try again later.',
          statusCode: statusCode,
        );
      default:
        return AppException(
          message: message,
          statusCode: statusCode,
          data: data,
        );
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['detail'] as String?;
    }
    return null;
  }
}
