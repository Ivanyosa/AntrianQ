import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

enum AuthStatus { initial, loading, authenticated, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({required this.status, this.errorMessage});

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);

  factory AuthState.authenticated() =>
      const AuthState(status: AuthStatus.authenticated);

  factory AuthState.error(String msg) =>
      AuthState(status: AuthStatus.error, errorMessage: msg);
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _service;

  AuthNotifier(this._service) : super(AuthState.initial());

  Future<void> login(String email, String password) async {
    try {
      state = AuthState.loading();

      await _service.signIn(email: email, password: password);

      state = AuthState.authenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> register(String email, String password) async {
    try {
      state = AuthState.loading();

      await _service.signUp(email: email, password: password);

      state = AuthState.authenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});
