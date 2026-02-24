enum Environment { development, staging, production }

class FlavorConfig {
  final Environment environment;
  final String apiBaseUrl;
  final String sentryDsn;
  // Add other environment-specific variables here like analytics keys, feature flags etc.

  static FlavorConfig? _instance;

  FlavorConfig._internal({
    required this.environment,
    required this.apiBaseUrl,
    required this.sentryDsn,
  });

  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception(
        'FlavorConfig is not initialized! Call FlavorConfig.init() before use.',
      );
    }
    return _instance!;
  }

  static void init({
    required Environment environment,
    required String apiBaseUrl,
    required String sentryDsn,
  }) {
    _instance ??= FlavorConfig._internal(
      environment: environment,
      apiBaseUrl: apiBaseUrl,
      sentryDsn: sentryDsn,
    );
  }

  bool get isDevelopment => environment == Environment.development;
  bool get isStaging => environment == Environment.staging;
  bool get isProduction => environment == Environment.production;
}
