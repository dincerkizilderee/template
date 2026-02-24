import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../core/cache/cache_manager.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
        redirect: (context, state) async {
          // Uygulama açılışında token kontrolü yap
          final box = await CacheManager.openBox<String>('authBox');
          final token = box.get('access_token');

          await Future.delayed(
            const Duration(milliseconds: 1500),
          ); // Splash ekranının görünmesi için simüle edilmiş bekleme süresi

          if (token != null && token.isNotEmpty) {
            return '/home';
          }
          return '/login';
        },
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    ],
  );
}
