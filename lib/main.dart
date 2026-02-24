import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'core/config/flavor_config.dart';
import 'core/cache/cache_manager.dart';
import 'core/di/injection.dart';
import 'router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/logger.dart';

/// Tüm flavor (ortam) varyantları için ortak başlatma (bootstrap) mantığı
Future<void> bootstrap(Widget Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Önbellek (Cache) Yöneticisini Başlat
  await CacheManager.init();

  // Bağımlılık Enjeksiyonunu (Dependency Injection) Başlat
  configureDependencies();

  Log.i(
    'Uygulama başlatılıyor (Ortam: ${FlavorConfig.instance.environment.name})...',
  );

  await SentryFlutter.init(
    (options) {
      options.dsn = FlavorConfig.instance.sentryDsn;
      // Performans izleme için tracesSampleRate 1.0 yapılarak işlemlerin %100'ü yakalanır.
      // Proje canlıya çıkarken (production) bu değerin düşürülmesi önerilir (Örn: 0.2).
      options.tracesSampleRate = FlavorConfig.instance.isProduction ? 0.2 : 1.0;
      options.environment = FlavorConfig.instance.environment.name;
    },
    appRunner: () => runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('tr')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: ProviderScope(child: builder()),
      ),
    ),
  );
}

class IztekApp extends ConsumerWidget {
  const IztekApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Burada final router = ref.watch(routerProvider); gibi bir kullanım da yapılabilir
    // Şimdilik AppRouter içerisindeki statik yapı tercih edildi.

    return MaterialApp.router(
      title: 'Core UI Template',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Veya state üzerinden okunabilir
      routerConfig: AppRouter.router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}
