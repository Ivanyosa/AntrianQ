import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user == null) {
      throw Exception("Gagal membuat akun");
    }

    await _client.from('profiles').insert({
      'id': user.id,
      'username': username,
      'role': 'user',
    });
  }

  Future<void> login({required String email, required String password}) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  User? get currentUser {
    return _client.auth.currentUser;
  }

  bool get isLoggedIn {
    return currentUser != null;
  }

  Future<String> getUserRole() async {
    final user = _client.auth.currentUser;

    print("AUTH USER ID: ${user?.id}");

    final profile = await _client
        .from('profiles')
        .select()
        .eq('id', user!.id)
        .single();

    print("PROFILE DATA: $profile");

    return profile['role'];
  }
}
