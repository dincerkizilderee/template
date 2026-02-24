import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Sentry.captureException(
      err,
      stackTrace: err.stackTrace,
      withScope: (scope) {
        scope.setContexts('DioError', {
          'url': err.requestOptions.path,
          'method': err.requestOptions.method,
          'statusCode': err.response?.statusCode,
          'message': err.message,
        });
      },
    );
    super.onError(err, handler);
  }
}
