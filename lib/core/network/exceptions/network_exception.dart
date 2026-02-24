import 'package:dio/dio.dart';

/// A custom exception class for handling network-related errors gracefully.
class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;

  NetworkException({required this.message, this.statusCode, this.code});

  factory NetworkException.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.cancel:
        return NetworkException(message: 'Request to API server was cancelled');
      case DioExceptionType.connectionTimeout:
        return NetworkException(message: 'Connection timeout with API server');
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Receive timeout in connection with API server',
        );
      case DioExceptionType.sendTimeout:
        return NetworkException(
          message: 'Send timeout in connection with API server',
        );
      case DioExceptionType.connectionError:
        return NetworkException(message: 'No Internet connection');
      case DioExceptionType.badCertificate:
        return NetworkException(message: 'Bad certificate');
      case DioExceptionType.badResponse:
        return _handleErrorResponse(
          dioException.response?.statusCode,
          dioException.response?.data,
        );
      case DioExceptionType.unknown:
        return NetworkException(
          message: 'Unexpected error occurred: ${dioException.message}',
        );
    }
  }

  static NetworkException _handleErrorResponse(int? statusCode, dynamic data) {
    final String message =
        data is Map<String, dynamic> && data['message'] != null
        ? data['message']
        : 'Received invalid status code: $statusCode';

    switch (statusCode) {
      case 400:
        return NetworkException(
          message: message,
          statusCode: statusCode,
          code: 'Bad Request',
        );
      case 401:
        return NetworkException(
          message: 'Unauthorized access',
          statusCode: statusCode,
          code: 'Unauthorized',
        );
      case 403:
        return NetworkException(
          message: 'Forbidden access',
          statusCode: statusCode,
          code: 'Forbidden',
        );
      case 404:
        return NetworkException(
          message: message,
          statusCode: statusCode,
          code: 'Not Found',
        );
      case 409:
        return NetworkException(
          message: 'Conflict occurred',
          statusCode: statusCode,
          code: 'Conflict',
        );
      case 408:
        return NetworkException(
          message: 'Request timeout',
          statusCode: statusCode,
          code: 'Request Timeout',
        );
      case 500:
        return NetworkException(
          message: 'Internal server error',
          statusCode: statusCode,
          code: 'Internal Server Error',
        );
      case 503:
        return NetworkException(
          message: 'Service unavailable',
          statusCode: statusCode,
          code: 'Service Unavailable',
        );
      default:
        return NetworkException(
          message: 'Oops something went wrong',
          statusCode: statusCode,
          code: 'Unknown Error',
        );
    }
  }

  @override
  String toString() =>
      'NetworkException(message: $message, statusCode: $statusCode, code: $code)';
}
