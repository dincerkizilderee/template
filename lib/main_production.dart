import 'core/config/flavor_config.dart';
import 'main.dart';

void main() {
  FlavorConfig.init(
    environment: Environment.production,
    apiBaseUrl: 'https://api.example.com/',
    sentryDsn: '', // Canlı (Production) Sentry DSN'inizi buraya ekleyin
  );

  bootstrap(() => const IztekApp());
}
