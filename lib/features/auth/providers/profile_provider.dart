import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final profileProvider = StreamProvider.autoDispose<Map<String, dynamic>>((ref) {
  final client = Supabase.instance.client;

  final user = client.auth.currentUser!;

  return client
      .from('profiles')
      .stream(primaryKey: ['id'])
      .eq('id', user.id)
      .map((event) => event.first);
});
