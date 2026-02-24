import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user.dart';
import '../../../../core/utils/logger.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String email, String password);
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(@Named('AuthDio') this.dio);

  @override
  Future<User> login(String email, String password) async {
    Log.i('Giriş isteği atılıyor... Email: $email');
    // Ağ (Network) gecikmesini simüle et
    await Future.delayed(const Duration(seconds: 1));

    // Kimlik doğrulamayı (Authentication) simüle et
    if (email == 'test@iztek.com' && password == 'password') {
      Log.i('Giriş başarılı. Email: $email');
      return const User(id: '1', name: 'Iztek User', email: 'test@iztek.com');
    } else {
      Log.w('Giriş başarısız. Hatalı kimlik bilgileri: $email');
      throw Exception('Invalid credentials');
    }
  }
}
