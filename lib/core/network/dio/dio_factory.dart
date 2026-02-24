import 'package:dio/dio.dart';
import '../constants/network_constants.dart';
import 'sentry_interceptor.dart';
import 'token_interceptor.dart';

class DioFactory {
  /// Belirli bir mikroservis temel URL'si için özelleştirilmiş Dio örneği oluşturur.
  static Dio create(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(
          milliseconds: NetworkConstants.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: NetworkConstants.receiveTimeout,
        ),
        headers: NetworkConstants.defaultHeaders,
      ),
    );

    // Ortak interceptor'leri ekle
    dio.interceptors.addAll([
      TokenInterceptor(dio: dio),
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
      SentryInterceptor(),
    ]);

    return dio;
  }
}
