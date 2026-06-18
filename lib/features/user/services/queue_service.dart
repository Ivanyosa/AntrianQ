import 'package:supabase_flutter/supabase_flutter.dart';

class QueueService {
  final _client = Supabase.instance.client;
  SupabaseClient get client => _client;

  /// Ambil daftar usaha
  Future<List<Map<String, dynamic>>> getBusinesses() async {
    final response = await _client
        .from('businesses')
        .select()
        .eq('approval_status', 'approved')
        .order('created_at');

    return List<Map<String, dynamic>>.from(response);
  }

  /// Ambil antrian menggunakan RPC
  Future<int> takeQueue(String businessId) async {
    final result = await _client.rpc(
      'take_queue',
      params: {'p_business_id': businessId},
    );

    return result as int;
  }

  /// Ambil antrian aktif user
  Future<Map<String, dynamic>?> getMyQueue() async {
    final user = _client.auth.currentUser;

    if (user == null) return null;

    final response = await _client
        .from('queues')
        .select('''
          *,
          businesses(
            name,
            current_queue,
            service_duration
          )
        ''')
        .eq('user_id', user.id)
        .eq('status', 'waiting')
        .order('created_at', ascending: false)
        .limit(1);

    if (response.isEmpty) {
      return null;
    }

    return response.first;
  }

  /// Batalkan antrian
  Future<void> cancelQueue(String queueId) async {
    await _client
        .from('queues')
        .update({'status': 'cancelled'})
        .eq('id', queueId);
  }

  Future<List<Map<String, dynamic>>> getQueueHistory() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      return [];
    }

    final response = await _client
        .from('queues')
        .select('''
        *,
        businesses(name)
      ''')
        .eq('user_id', user.id)
        .neq('status', 'waiting')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> registerBusiness({
    required String name,
    required String location,
    required String description,
    required int serviceDuration,
    required int maxDailyQueue,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    await _client.from('businesses').insert({
      'owner_id': user.id,
      'name': name,
      'location': location,
      'description': description,
      'service_duration': serviceDuration,
      'max_daily_queue': maxDailyQueue,
      'status': 'closed',
      'approval_status': 'pending',
    });
  }

  Future<Map<String, dynamic>?> getMyBusiness() async {
    final user = _client.auth.currentUser;

    if (user == null) return null;

    final response = await _client
        .from('businesses')
        .select()
        .eq('owner_id', user.id)
        .eq('approval_status', 'approved')
        .limit(1);

    if (response.isEmpty) {
      return null;
    }

    return response.first;
  }

  Future<Map<String, dynamic>> nextQueue(String businessId) async {
    final result = await _client.rpc(
      'next_queue',
      params: {'p_business_id': businessId},
    );

    return Map<String, dynamic>.from(result);
  }

  Future<void> updateBusinessStatus(String businessId, String status) async {
    await _client
        .from('businesses')
        .update({'status': status})
        .eq('id', businessId);
  }

  Future<Map<String, int>> getAdminStats() async {
    final users = await _client.from('profiles').select('id');

    final businesses = await _client.from('businesses').select('id');

    final activeQueues = await _client
        .from('queues')
        .select('id')
        .eq('status', 'waiting');

    return {
      'users': users.length,
      'businesses': businesses.length,
      'activeQueues': activeQueues.length,
    };
  }

  Future<List<Map<String, dynamic>>> getPendingBusinesses() async {
    final response = await _client
        .from('businesses')
        .select()
        .eq('approval_status', 'pending')
        .order('created_at');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> approveBusiness(String businessId) async {
    await _client
        .from('businesses')
        .update({'approval_status': 'approved', 'status': 'closed'})
        .eq('id', businessId);
  }

  Future<void> rejectBusiness(String businessId) async {
    await _client
        .from('businesses')
        .update({'approval_status': 'rejected'})
        .eq('id', businessId);
  }

  Future<bool> isOwner() async {
    final user = _client.auth.currentUser;

    if (user == null) return false;

    final response = await _client
        .from('businesses')
        .select('id')
        .eq('owner_id', user.id)
        .eq('approval_status', 'approved')
        .limit(1);

    return response.isNotEmpty;
  }

  Future<void> openBusiness(String businessId) async {
    await _client.rpc('open_business', params: {'p_business_id': businessId});
  }

  Future<void> closeBusiness(String businessId) async {
    await _client.rpc('close_business', params: {'p_business_id': businessId});
  }

  Future<void> setBreakStatus(String businessId) async {
    await _client
        .from('businesses')
        .update({'status': 'break'})
        .eq('id', businessId);
  }

  Future<void> submitBusinessUpdate({
    required String businessId,
    required Map<String, dynamic> payload,
  }) async {
    await _client.from('business_update_requests').insert({
      'business_id': businessId,
      'payload': payload,
      'status': 'pending',
    });
  }

  Future<List<Map<String, dynamic>>> getPendingUpdateRequests() async {
    final response = await _client
        .from('business_update_requests')
        .select('''
        *,
        businesses(name)
      ''')
        .eq('status', 'pending');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> approveUpdateRequest(String requestId) async {
    final request = await _client
        .from('business_update_requests')
        .select()
        .eq('id', requestId)
        .single();

    final payload = Map<String, dynamic>.from(request['payload']);

    await _client
        .from('businesses')
        .update(payload)
        .eq('id', request['business_id']);

    await _client
        .from('business_update_requests')
        .update({'status': 'approved'})
        .eq('id', requestId);
  }

  Future<void> rejectUpdateRequest(String requestId) async {
    await _client
        .from('business_update_requests')
        .update({'status': 'rejected'})
        .eq('id', requestId);
  }

  Stream<Map<String, dynamic>?> watchMyQueue() {
    final user = _client.auth.currentUser;

    if (user == null) {
      return Stream.value(null);
    }

    return _client
        .from('queues')
        .stream(primaryKey: ['id'])
        .eq('user_id', user.id)
        .asyncMap((queues) async {
          final waiting = queues.where((q) => q['status'] == 'waiting');

          if (waiting.isEmpty) {
            return null;
          }

          waiting.toList().sort(
            (a, b) => DateTime.parse(
              b['created_at'],
            ).compareTo(DateTime.parse(a['created_at'])),
          );

          final latest = waiting.first;

          final fullQueue = await _client
              .from('queues')
              .select('''
              *,
              businesses(*)
            ''')
              .eq('id', latest['id'])
              .single();

          return fullQueue;
        });
  }

  Stream<Map<String, dynamic>?> watchMyBusiness() {
    final user = _client.auth.currentUser;

    if (user == null) {
      return Stream.value(null);
    }

    return _client
        .from('businesses')
        .stream(primaryKey: ['id'])
        .eq('owner_id', user.id)
        .map((businesses) {
          if (businesses.isEmpty) {
            return null;
          }

          final business = businesses.firstWhere(
            (b) => b['owner_id'] == user.id,
            orElse: () => businesses.first,
          );

          return Map<String, dynamic>.from(business);
        });
  }

  Stream<List<Map<String, dynamic>>> watchBusinesses() {
    return _client
        .from('businesses')
        .stream(primaryKey: ['id'])
        .map(
          (data) => data
              .where((b) => b['approval_status'] == 'approved')
              .map((e) => Map<String, dynamic>.from(e))
              .toList(),
        );
  }
}
