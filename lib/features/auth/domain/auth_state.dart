import '../../../../core/auth/auth_service.dart';

class AuthState {
  final AuthStatus status;
  final AuthTokens? tokens;
  final String? errorMessage;

  const AuthState._({
    required this.status,
    this.tokens,
    this.errorMessage,
  });

  const AuthState.initial() : this._(status: AuthStatus.initial);
  const AuthState.loading() : this._(status: AuthStatus.loading);
  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  const AuthState.authenticated({required AuthTokens tokens})
      : this._(status: AuthStatus.authenticated, tokens: tokens);

  const AuthState.error({required String message})
      : this._(status: AuthStatus.error, errorMessage: message);

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get isInitial => status == AuthStatus.initial;
  bool get hasError => status == AuthStatus.error;

  String? get accessToken => tokens?.accessToken;
}

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}
