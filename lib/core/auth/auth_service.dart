import 'package:flutter_appauth/flutter_appauth.dart';
import '../constants/app_constants.dart';
import '../storage/secure_storage.dart';

class AuthService {
  final FlutterAppAuth _appAuth;
  final SecureStorage _storage;

  AuthService({
    FlutterAppAuth? appAuth,
    SecureStorage? storage,
  })  : _appAuth = appAuth ?? const FlutterAppAuth(),
        _storage = storage ?? SecureStorage();

  /// Perform PKCE login flow
  Future<AuthTokens?> login() async {
    try {
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AppConstants.clientId,
          AppConstants.redirectUrl,
          issuer: AppConstants.issuerUrl,
          scopes: AppConstants.scopes,
          promptValues: ['login'],
        ),
      );

      if (result == null) return null;

      final tokens = AuthTokens(
        accessToken: result.accessToken ?? '',
        refreshToken: result.refreshToken ?? '',
        idToken: result.idToken ?? '',
        tokenExpiry: result.accessTokenExpirationDateTime,
      );

      await _persistTokens(tokens);
      return tokens;
    } catch (e) {
      rethrow;
    }
  }

  /// Refresh access token using refresh token
  Future<AuthTokens?> refreshToken() async {
    final refreshToken = await _storage.read(key: AppConstants.refreshTokenKey);
    if (refreshToken == null || refreshToken.isEmpty) return null;

    try {
      final result = await _appAuth.token(
        TokenRequest(
          AppConstants.clientId,
          AppConstants.redirectUrl,
          issuer: AppConstants.issuerUrl,
          refreshToken: refreshToken,
          scopes: AppConstants.scopes,
        ),
      );

      if (result == null) return null;

      final tokens = AuthTokens(
        accessToken: result.accessToken ?? '',
        refreshToken: result.refreshToken ?? refreshToken,
        idToken: result.idToken ?? '',
        tokenExpiry: result.accessTokenExpirationDateTime,
      );

      await _persistTokens(tokens);
      return tokens;
    } catch (e) {
      await logout();
      rethrow;
    }
  }

  /// End session / logout
  Future<void> logout() async {
    try {
      final idToken = await _storage.read(key: AppConstants.idTokenKey);
      if (idToken != null) {
        await _appAuth.endSession(
          EndSessionRequest(
            idTokenHint: idToken,
            issuer: AppConstants.issuerUrl,
            postLogoutRedirectUrl: AppConstants.endSessionRedirectUrl,
          ),
        );
      }
    } catch (_) {
      // Ignore errors during logout
    } finally {
      await _storage.deleteAll();
    }
  }

  /// Load tokens from storage
  Future<AuthTokens?> loadStoredTokens() async {
    final accessToken = await _storage.read(key: AppConstants.accessTokenKey);
    if (accessToken == null || accessToken.isEmpty) return null;

    final refreshToken = await _storage.read(key: AppConstants.refreshTokenKey);
    final idToken = await _storage.read(key: AppConstants.idTokenKey);
    final expiryStr = await _storage.read(key: AppConstants.tokenExpiryKey);

    DateTime? expiry;
    if (expiryStr != null) {
      expiry = DateTime.tryParse(expiryStr);
    }

    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken ?? '',
      idToken: idToken ?? '',
      tokenExpiry: expiry,
    );
  }

  /// Check if current access token is expired
  Future<bool> isTokenExpired() async {
    final expiryStr = await _storage.read(key: AppConstants.tokenExpiryKey);
    if (expiryStr == null) return true;
    final expiry = DateTime.tryParse(expiryStr);
    if (expiry == null) return true;
    return DateTime.now().isAfter(expiry.subtract(const Duration(minutes: 1)));
  }

  Future<void> _persistTokens(AuthTokens tokens) async {
    await Future.wait([
      _storage.write(key: AppConstants.accessTokenKey, value: tokens.accessToken),
      _storage.write(key: AppConstants.refreshTokenKey, value: tokens.refreshToken),
      _storage.write(key: AppConstants.idTokenKey, value: tokens.idToken),
      if (tokens.tokenExpiry != null)
        _storage.write(
          key: AppConstants.tokenExpiryKey,
          value: tokens.tokenExpiry!.toIso8601String(),
        ),
    ]);
  }
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final String idToken;
  final DateTime? tokenExpiry;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.idToken,
    this.tokenExpiry,
  });

  bool get isExpired {
    if (tokenExpiry == null) return true;
    return DateTime.now().isAfter(tokenExpiry!.subtract(const Duration(minutes: 1)));
  }

  @override
  String toString() =>
      'AuthTokens(accessToken: ${accessToken.substring(0, accessToken.length > 10 ? 10 : accessToken.length)}..., expiry: $tokenExpiry)';
}
