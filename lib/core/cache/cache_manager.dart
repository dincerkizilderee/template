import 'package:hive_flutter/hive_flutter.dart';

class CacheManager {
  static Future<void> init() async {
    await Hive.initFlutter();
    // Register Adapters here e.g:
    // Hive.registerAdapter(UserModelAdapter());
  }

  static Future<Box<T>> openBox<T>(String boxName) async {
    return await Hive.openBox<T>(boxName);
  }
}
