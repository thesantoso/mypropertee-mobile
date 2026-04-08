import 'auth_service.dart';

abstract class AuthRepository {
  Future<AuthTokens?> login();
  Future<AuthTokens?> refreshToken();
  Future<void> logout();
  Future<AuthTokens?> loadStoredTokens();
  Future<bool> isTokenExpired();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl({required AuthService authService})
      : _authService = authService;

  @override
  Future<AuthTokens?> login() => _authService.login();

  @override
  Future<AuthTokens?> refreshToken() => _authService.refreshToken();

  @override
  Future<void> logout() => _authService.logout();

  @override
  Future<AuthTokens?> loadStoredTokens() => _authService.loadStoredTokens();

  @override
  Future<bool> isTokenExpired() => _authService.isTokenExpired();
}
