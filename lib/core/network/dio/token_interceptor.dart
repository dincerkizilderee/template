import 'package:dio/dio.dart';
import '../../cache/cache_manager.dart'; // İleride yetkilendirme (auth) cache/storage yapısına soyutlanacağı varsayıldı
import '../../utils/logger.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;

  // Yeni bir token alındığında tekrar denemek üzere başarısız isteklerin listesini tutarız.
  final _requestsToRetry = <RequestOptions>[];
  bool _isRefreshing = false;

  TokenInterceptor({required this.dio});

  Future<String?> _getToken(String key) async {
    final box = await CacheManager.openBox('authBox');
    return box.get(key) as String?;
  }

  Future<void> _deleteToken(String key) async {
    final box = await CacheManager.openBox('authBox');
    await box.delete(key);
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Varsa, access token'ı başlığa (header) enjekte et
    final token = await _getToken('access_token');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Sadece 401 Yetkisiz (Unauthorized) hatasını işle
    if (err.response?.statusCode == 401) {
      // Eğer token zaten yenilenmiyorsa işleme başla
      if (!_isRefreshing) {
        _isRefreshing = true;

        // Başarısız olan isteği kaydet ki daha sonra tekrar deneyebilelim
        _requestsToRetry.add(err.requestOptions);

        final tokenRefreshed = await _refreshToken();

        _isRefreshing = false;

        if (tokenRefreshed) {
          // Eğer token başarıyla yenilendiyse, kaydedilen tüm istekleri tekrar dene
          await _retrySavedRequests(handler);
          return;
        } else {
          // Yenileme başarısız olursa, kullanıcının çıkışını yapmamız gerekir.
          // Gerçek bir uygulamada, önbelleği temizleyip Giriş (Login) ekranına yönlendirirsiniz.
          await _deleteToken('access_token');
          await _deleteToken('refresh_token');
          // e.g. appRouter.go('/login');
          return handler.next(err);
        }
      } else {
        // Eğer token yenileme işlemi zaten devam ediyorsa, başarısız isteği kuyruğa ekle
        _requestsToRetry.add(err.requestOptions);
        return;
      }
    }

    // Hata 401 değilse bir sonraki interceptor'a geçir
    super.onError(err, handler);
  }

  Future<bool> _refreshToken() async {
    try {
      Log.i('Token yenileme (refresh) işlemi başlatılıyor...');
      final refreshToken = await _getToken('refresh_token');
      if (refreshToken == null) {
        Log.w('Refresh token bulunamadı, yenileme yapılamıyor.');
        return false;
      }

      // Gerçek bir uygulamada yenileme (refresh) işlemi için ilgili endpoint'e istek atılır
      // final response = await dio.post(AuthEndpoints.refreshToken, data: {'refresh_token': refreshToken});
      // final newAccessToken = response.data['access_token'];
      // final box = await CacheManager.openBox('authBox');
      // await box.put('access_token', newAccessToken);

      Log.i('Token başarıyla yenilendi.');
      return true;
    } catch (e, stackTrace) {
      Log.e('Token yenileme işlemi başarısız oldu.', e, stackTrace);
      return false;
    }
  }

  Future<void> _retrySavedRequests(ErrorInterceptorHandler handler) async {
    Log.d(
      '${_requestsToRetry.length} adet başarısız istek tekrar deneniyor...',
    );
    final token = await _getToken('access_token');

    for (var requestOptions in _requestsToRetry) {
      requestOptions.headers['Authorization'] = 'Bearer $token';
      try {
        // İsteği tekrar dene
        final response = await dio.fetch(requestOptions);
        handler.resolve(response);
      } on DioException catch (e) {
        handler.next(e);
      }
    }

    _requestsToRetry.clear();
  }
}
