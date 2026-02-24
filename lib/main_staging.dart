import 'core/config/flavor_config.dart';
import 'main.dart';

void main() {
  FlavorConfig.init(
    environment: Environment.staging,
    apiBaseUrl: 'https://staging-api.example.com/',
    sentryDsn: '', // Staging Sentry DSN'inizi buraya ekleyin
  );

  bootstrap(() => const IztekApp());
}
