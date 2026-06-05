import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:media_crunchy/models/user_profile_model.dart';
import 'package:media_crunchy/services/auth_service.dart';
import 'package:media_crunchy/services/supabase_service.dart';

class AuthState {
  final bool loading;
  final String? error;
  final User? user;
  final UserProfileModel? profile;

  const AuthState({this.loading = false, this.error, this.user, this.profile});

  AuthState copyWith({
    bool? loading,
    String? error,
    User? user,
    UserProfileModel? profile,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      error: error,
      user: user ?? this.user,
      profile: profile ?? this.profile,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authService, this._supabaseService)
    : super(const AuthState()) {
    loadCurrentUser();
  }

  final AuthService _authService;
  final SupabaseService _supabaseService;

  Future<void> loadCurrentUser() async {
    state = state.copyWith(loading: true, error: null);
    final currentUser = _authService.currentUser;

    if (currentUser == null) {
      state = state.copyWith(loading: false, user: null, profile: null);
      return;
    }

    final profile = await _supabaseService.ensureUserProfile(currentUser);
    state = state.copyWith(loading: false, user: currentUser, profile: profile);
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final user = await _authService.signInWithEmail(email, password);
      if (user != null) {
        final profile = await _supabaseService.ensureUserProfile(user);
        state = state.copyWith(loading: false, user: user, profile: profile);
      } else {
        state = state.copyWith(loading: false, user: null, profile: null);
      }
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<void> signUp(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final user = await _authService.signUpWithEmail(email, password);
      if (user != null) {
        final profile = await _supabaseService.ensureUserProfile(user);
        state = state.copyWith(loading: false, user: user, profile: profile);
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
  (ref) => AuthNotifier(
    ref.read(authServiceProvider),
    ref.read(supabaseServiceProvider),
  ),
);
