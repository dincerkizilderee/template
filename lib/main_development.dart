import 'core/config/flavor_config.dart';
import 'main.dart';

void main() {
  FlavorConfig.init(
    environment: Environment.development,
    apiBaseUrl: 'https://dev-api.example.com/',
    sentryDsn: '', // Dev Sentry DSN'inizi buraya ekleyin
  );

  bootstrap(() => const IztekApp());
}
