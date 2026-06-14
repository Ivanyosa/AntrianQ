import 'package:supabase_flutter/supabase_flutter.dart';

class QueueService {
  final _client = Supabase.instance.client;

  Future<void> takeQueue(int serviceId) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    // CEK APAKAH MASIH PUNYA ANTRIAN AKTIF
    final existingQueue = await _client
        .from('queues')
        .select()
        .eq('user_id', user.id)
        .eq('status', 'waiting');

    if (existingQueue.isNotEmpty) {
      throw Exception('Anda masih memiliki antrian aktif');
    }

    final service = await _client
        .from('services')
        .select()
        .eq('id', serviceId)
        .single();

    final serviceName = service['name'];

    String prefix = serviceName.split(' ').last;

    final existingQueues = await _client
        .from('queues')
        .select()
        .eq('service_id', serviceId);

    final nextNumber = existingQueues.length + 1;

    final queueNumber = '$prefix-${nextNumber.toString().padLeft(3, '0')}';

    await _client.from('queues').insert({
      'user_id': user.id,
      'service_id': serviceId,
      'queue_number': queueNumber,
      'status': 'waiting',
    });
  }
  // Future<List<Map<String, dynamic>>> getServices() async {
  //   final response = await _client
  //       .from('services')
  //       .select()
  //       .eq('is_active', true);

  //   return List<Map<String, dynamic>>.from(response);
  // }
  Future<List<Map<String, dynamic>>> getServices() async {
    // final response = await _client
    //     .from('services')
    //     .select()
    //     .eq('is_active', true);
    final response = await _client.from('services').select();

    print("SERVICES: $response");

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getMyQueue() async {
    final user = _client.auth.currentUser;

    if (user == null) return null;

    final response = await _client
        .from('queues')
        .select('*, services(name)')
        .eq('user_id', user.id)
        .eq('status', 'waiting')
        .order('created_at', ascending: false)
        .limit(1);

    if (response.isEmpty) {
      return null;
    }

    return response.first;
  }
}
