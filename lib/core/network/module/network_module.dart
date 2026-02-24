import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../constants/network_constants.dart';
import '../dio/dio_factory.dart';

@module
abstract class NetworkModule {
  /// Provides a Dio instance configured specifically for the Authentication Microservice.
  @Named('AuthDio')
  @lazySingleton
  Dio get authDio => DioFactory.create(NetworkConstants.authBaseUrl);

  /// Provides a Dio instance configured specifically for the User Microservice.
  @Named('UserDio')
  @lazySingleton
  Dio get userDio => DioFactory.create(NetworkConstants.userBaseUrl);

  /// Provides a Dio instance configured specifically for the Products Microservice.
  @Named('ProductsDio')
  @lazySingleton
  Dio get productsDio => DioFactory.create(NetworkConstants.productsBaseUrl);
}
