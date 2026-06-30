import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class FcmService {
  final _messaging = FirebaseMessaging.instance;
  final _client = Supabase.instance.client;

  Future<void> initialize() async {
    if (kIsWeb) return;
    // Minta izin notifikasi
    await _messaging.requestPermission();

    // Ambil token HP
    final token = await _messaging.getToken();

    print("FCM TOKEN: $token");

    final user = _client.auth.currentUser;

    if (user != null && token != null) {
      await _client.from('fcm_tokens').upsert({
        'user_id': user.id,
        'token': token,
      }, onConflict: 'user_id');
    }

    // Jika token berubah
    _messaging.onTokenRefresh.listen((newToken) async {
      final currentUser = _client.auth.currentUser;

      if (currentUser != null) {
        await _client.from('fcm_tokens').upsert({
          'user_id': currentUser.id,
          'token': newToken,
        }, onConflict: 'user_id');
      }
    });
  }
}
