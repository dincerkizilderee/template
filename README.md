# Core UI Template - Enterprise Flutter Projesi

Bu proje, Flutter ile geliştirilmiş, büyük ölçekli ve kurumsal seviye uygulamalar geliştirmek için hazırlanmış **Clean Architecture** tabanlı kusursuz bir proje şablonudur. (Template)

## 🚀 Projede Vurgulanan Özellikler & Mimariler

Bu şablon, sıfırdan bir uygulamaya başlarken aylar sürebilecek altyapı kurulumlarını saniyeler içinde size sunar:

### 1. Clean Architecture (Temiz Mimari)
Proje klasör yapısı `Domain`, `Data` ve `Presentation` katmanlarına ayrılmıştır. İş kuralları (Business logic) UI'dan tamamen izoledir. Veri yönetimi Repository Pattern ile sağlanır.

### 2. Dependency Injection (Bağımlılık Enjeksiyonu)
Bağımlılıklar `get_it` ve `injectable` kullanılarak yönetilir. Sınıflar birbirine sıkı sıkıya bağlı değildir, test edilebilirlikleri en üst düzeydedir. (Bkz: `lib/core/di/injection.dart`)

### 3. Çoklu Ortam (Flavors: Dev, Staging, Prod)
Uygulama; Geliştirme (Development), Test (Staging) ve Canlı (Production) ortamları olmak üzere 3 farklı `main` giriş noktasına sahiptir. API URL'leri ve Sentry DSN'leri gibi hassas yapılandırmalar `FlavorConfig` ile ortama göre dinamik değişir. (VS Code üzerinden doğrudan ilgili ortamı başlatabilirsiniz).

### 4. Güçlü Network Katmanı (Dio & Interceptors)
Tüm ağ istekleri konfigüre edilmiş `Dio` instance'ları üzerinden geçer (`DioFactory`).
- **NetworkException**: Hatalar, anlaşılır ve handle edilebilir custom exception'lara dönüştürülür.
- **TokenInterceptor**: `401 Unauthorized` hatalarında kullanıcıyı uygulamadan atmak yerine arkada sessizce `refresh_token` ile yenileme yapar ve başarısız istekleri tekrar dener. (Kuyruk yapısı mevcuttur).
- **SentryInterceptor**: Uygulamadaki tüm HTTP hatalarını anında Sentry dashboard'una raporlar.

### 5. Akıllı Yönlendirme (GoRouter & Splash Screen)
Sayfa geçişleri için Flutter'ın resmi önerisi olan `go_router` kullanıldı. Uygulama açılışında `SplashPage` gösterilir ve kullanıcının `access_token`'ı kontrol edilerek anında `/home` veya `/login` ekranına yönlendirilir (Redirect logic).

### 6. State Management (Riverpod)
Uygulamanın durum (state) yönetimi modern, güvenli ve test edilebilir olan `flutter_riverpod` (ve kod üretimi için `riverpod_generator`) ile kurgulandı.

### 7. Güvenli Kod Süreçleri (CI/CD & Git Hooks)
- **Git Hooks:** `pre-commit` hook'u sayesinde, kodlarınız `flutter format` ve `flutter analyze` kurallarından geçmezse Git commit atılmasına izin vermez. Hatalı kodların repoya girmesi imkansızdır.
- **GitHub Actions:** Açılan her PR ve Push işleminde otomatize edilmiş CI/CD pipeline'ı çalışarak build testlerini gerçekleştirir. (`.github/workflows/flutter_ci.yml`)

### 8. Çoklu Dil Desteği (easy_localization)
Projeye yeni diller eklemek sadece `/assets/translations/` içerisine JSON dosyaları oluşturmak kadar kolaydır. Çeviriler, kod üretimi sayesinde type-safe (ör: `LocaleKeys.login_title.tr()`) olarak kullanılır.

### 9. Merkezi Form Validasyonu (formz)
Form girdilerindeki e-posta, şifre gibi validasyonlar `formz` kullanılarak UI içindeki spagetti if/else kodlarından temizler; doğrudan input class'ları içinde yönetilmesini sağlar. (Bkz: `lib/core/utils/validators/`)

### 10. Duyarlı Tasarım (Responsive Framework)
Uygulamanın arayüzü `ResponsiveBreakpoints` sarmalayıcısı sayesinde `MOBILE`, `TABLET`, `DESKTOP` ve `4K` gibi ekran kırılımlarına göre kendi iç düzenini otomatik olarak ayarlar. (Bkz: `main.dart`)

### 11. Profesyonel Loglama & Hata Takibi (Logger & Sentry)
Konsola sızan `print()` logları kapatıldı. Bunun yerine `Log.i()`, `Log.e()` global logger alt yapısı kuruldu. Canlı (Production) ortamda tüm loglar sessize alınırken, ölümcül (`Log.f`) ve standart hatalar otomatik olarak Sentry izleme platformuna aktarılır.

### 12. Test Altyapısı (mocktail)
Birim (Unit) testlerinin kolayca yazılabilmesi için `mocktail` entegre edilmiş, tüm repo/datasource yapılarının test iskeletleri hazırlanmıştır.

---

## 💻 Nasıl Ayağa Kaldırılır?

### 1. Projeyi Klonlayın
```bash
git clone <repo_url>
cd core_ui_template
```

### 2. Bağımlılıkları Yükleyin
```bash
flutter pub get
```

### 3. Kod Üretimi (Code Generation) Dosyalarını Oluşturun
Proje Injectable, Riverpod, Freezed vb. kütüphaneler kullandığı için öncelikle `build_runner` komutunun çalıştırılması zorunludur:
```bash
# Sadece bir kere çalıştırıp üretmek için:
dart run build_runner build --delete-conflicting-outputs

# Geliştirme anında anlık değişimleri takip etmesi için (Tavsiye edilir):
dart run build_runner watch --delete-conflicting-outputs
```

### 4. Git Hooks Etkinleştirin (Sadece İlk Kurulumda)
Geliştirici ortamınızı güvenceye almak için git kancalarını sisteminize tanıtın:
```bash
chmod +x scripts/setup_git_hooks.sh
./scripts/setup_git_hooks.sh
```

### 5. Uygulamayı Çalıştırın!
Projeyi hangi ortamda test etmek/build almak istiyorsanız ona göre çalıştırın:

**Komut Satırı ile:**
```bash
# Geliştirme (Development)
flutter run -t lib/main_development.dart --flavor development

# Canlı (Production)
flutter run -t lib/main_production.dart --flavor production
```

**VS Code ile:**
Sol menüdeki `Run and Debug` tabına giderek;
- `Flutter Dev`
- `Flutter Staging`
- `Flutter Prod`
seçeneklerinden birine tıklayıp doğrudan uygulamayı Play (F5) butonu ile ayağa kaldırabilirsiniz. (Konfigürasyonlar `.vscode/launch.json` içerisinde mevcuttur).

---
*Core UI Enterprise Template by Dinçer KIZILDERE*
