import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:media_crunchy/services/auth_service.dart';

class AuthState {
  final bool loading;
  final String? error;
  final User? user;

  const AuthState({this.loading = false, this.error, this.user});

  AuthState copyWith({bool? loading, String? error, User? user}) {
    return AuthState(
      loading: loading ?? this.loading,
      error: error,
      user: user ?? this.user,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authService) : super(const AuthState()) {
    loadCurrentUser();
  }

  final AuthService _authService;

  Future<void> loadCurrentUser() async {
    state = state.copyWith(loading: true, error: null);
    final currentUser = _authService.currentUser;
    state = state.copyWith(loading: false, user: currentUser);
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final user = await _authService.signInWithEmail(email, password);
      state = state.copyWith(loading: false, user: user);
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<void> signUp(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final user = await _authService.signUpWithEmail(email, password);
      if (user != null) {
        state = state.copyWith(loading: false, user: user);
      } else {
        state = state.copyWith(
          loading: false,
          error: 'Check your email for a confirmation link.',
        );
      }
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(loading: true, error: null);
    await _authService.signOut();
    state = const AuthState();
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authServiceProvider)),
);
