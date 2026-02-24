import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../config/flavor_config.dart';

class Log {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    // Canlı (production) ortamda logları gizle
    level: FlavorConfig.instance.isProduction ? Level.off : Level.trace,
  );

  /// Mesajı [Level.trace] seviyesinde logla.
  static void t(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  /// Mesajı [Level.debug] seviyesinde logla.
  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Mesajı [Level.info] seviyesinde logla.
  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Mesajı [Level.warning] seviyesinde logla.
  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Mesajı [Level.error] seviyesinde logla.
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);

    // Canlı ortamdaki hataları otomatik olarak Sentry'ye gönder
    if (FlavorConfig.instance.isProduction && error != null) {
      Sentry.captureException(
        error,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setContexts('Logging', {'message': message.toString()});
        },
      );
    }
  }

  /// Mesajı [Level.fatal] seviyesinde logla.
  static void f(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);

    // Ölümcül (fatal) hataları otomatik olarak Sentry'ye gönder
    if (error != null) {
      Sentry.captureException(
        error,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setContexts('Logging', {'message': message.toString()});
          scope.level = SentryLevel.fatal;
        },
      );
    }
  }
}
