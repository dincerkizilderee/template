class NetworkConstants {
  // Global configurations
  static const int connectTimeout = 10000; // in milliseconds
  static const int receiveTimeout = 10000; // in milliseconds

  // Common Headers
  static const Map<String, dynamic> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Microservice Base URLs
  // In a real app, these might come from .env files or flavor configs
  static const String authBaseUrl = 'https://auth.api.example.com/';
  static const String userBaseUrl = 'https://user.api.example.com/';
  static const String productsBaseUrl = 'https://products.api.example.com/';
}
