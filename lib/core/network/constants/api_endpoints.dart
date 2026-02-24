/// Defines all API paths for the Auth Microservice
class AuthEndpoints {
  static const String login = 'v1/auth/login';
  static const String register = 'v1/auth/register';
  static const String refreshToken = 'v1/auth/refresh';
  static const String logout = 'v1/auth/logout';
}

/// Defines all API paths for the User Microservice
class UserEndpoints {
  static const String profile = 'v1/users/profile';
  static const String settings = 'v1/users/settings';
  static String userDetails(String id) => 'v1/users/$id';
}

/// Defines all API paths for the Products Microservice
class ProductEndpoints {
  static const String getProducts = 'v1/products';
  static String getProductDetails(String id) => 'v1/products/$id';
}
