import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;

  Future<User?> signInWithEmail(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.user;
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<User?> signInAnonymously() async {
    final response = await _client.auth.signInWithPassword(
      email: 'anonymous@mediacrunchy.local',
      password: 'anonymous-password',
    );
    return response.user;
  }
}
