import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/auth_state.dart';
import '../../../../core/auth/auth_repository.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/auth/auth_service.dart';

// Storage Provider
final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return AuthService(storage: storage);
});

// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthRepositoryImpl(authService: authService);
});

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState.initial()) {
    _init();
  }

  Future<void> _init() async {
    state = const AuthState.loading();
    try {
      final tokens = await _repository.loadStoredTokens();
      if (tokens == null) {
        state = const AuthState.unauthenticated();
        return;
      }

      if (tokens.isExpired) {
        final refreshed = await _repository.refreshToken();
        if (refreshed != null) {
          state = AuthState.authenticated(tokens: refreshed);
        } else {
          state = const AuthState.unauthenticated();
        }
      } else {
        state = AuthState.authenticated(tokens: tokens);
      }
    } catch (_) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login() async {
    state = const AuthState.loading();
    try {
      final tokens = await _repository.login();
      if (tokens != null) {
        state = AuthState.authenticated(tokens: tokens);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(message: e.toString());
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState.unauthenticated();
  }

  Future<void> refreshToken() async {
    try {
      final tokens = await _repository.refreshToken();
      if (tokens != null) {
        state = AuthState.authenticated(tokens: tokens);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (_) {
      state = const AuthState.unauthenticated();
    }
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
