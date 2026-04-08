abstract class AppConstants {
  // API
  static const String baseUrl = 'https://api.mypropertee.com/v1';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Auth / OIDC (Authentik)
  static const String issuerUrl = 'https://auth.mypropertee.com/application/o/mypropertee/';
  static const String clientId = 'mypropertee-flutter';
  static const String redirectUrl = 'com.mypropertee.app://callback';
  static const String endSessionRedirectUrl = 'com.mypropertee.app://endsession';
  static const List<String> scopes = ['openid', 'profile', 'email', 'offline_access'];

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String idTokenKey = 'id_token';
  static const String tokenExpiryKey = 'token_expiry';
  static const String userProfileKey = 'user_profile';

  // Pagination
  static const int defaultPageSize = 20;
  static const int firstPage = 1;

  // Cache Duration
  static const Duration cacheExpiry = Duration(minutes: 5);
}
