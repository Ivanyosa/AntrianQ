import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QueueService {
  final _client = Supabase.instance.client;
  SupabaseClient get client => _client;

  Future<List<Map<String, dynamic>>> getBusinesses() async {
    final response = await _client
        .from('businesses')
        .select('''
  *,
  profiles!businesses_owner_id_fkey(
    username,
    avatar_index
  )
''')
        .order('created_at', ascending: false);

    debugPrint(response.toString());

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

  registerBusiness({
    required String name,
    required String location,
    required String description,
    required int serviceDuration,
    required int maxDailyQueue,
    XFile? image,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("Belum login");
    }

    String? logoUrl;

    if (image != null) {
      final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";

      await _client.storage
          .from("business-logo")
          .upload(fileName, File(image.path));

      logoUrl = _client.storage.from("business-logo").getPublicUrl(fileName);
    }

    await _client.from("businesses").insert({
      "owner_id": user.id,

      "name": name,

      "location": location,

      "description": description,

      "service_duration": serviceDuration,

      "max_daily_queue": maxDailyQueue,

      "logo_url": logoUrl,

      "status": "closed",

      "approval_status": "pending",
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
    final users = await _client
        .from('profiles')
        .select('id')
        .eq('role', 'user');

    final owners = await _client
        .from('profiles')
        .select('id')
        .eq('role', 'owner');

    final businesses = await _client.from('businesses').select('id');

    final today = DateTime.now().toIso8601String().split('T').first;

    final todayQueues = await _client
        .from('queues')
        .select('id')
        .eq('queue_date', today);

    final weekAgo = DateTime.now()
        .subtract(const Duration(days: 6))
        .toIso8601String()
        .split('T')
        .first;

    final weekQueues = await _client
        .from('queues')
        .select('id')
        .gte('queue_date', weekAgo);

    final monthAgo = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      1,
    ).toIso8601String().split('T').first;

    final monthQueues = await _client
        .from('queues')
        .select('id')
        .gte('queue_date', monthAgo);

    debugPrint("Users : ${users.length}");
    debugPrint("Owners : ${owners.length}");
    debugPrint("Business : ${businesses.length}");

    return {
      'users': users.length,
      'owners': owners.length,
      'businesses': businesses.length,
      'todayQueues': todayQueues.length,
      'weekQueues': weekQueues.length,
      'monthQueues': monthQueues.length,
    };
  }

  Future<void> approveBusiness(String businessId) async {
    final business = await _client
        .from('businesses')
        .select('owner_id')
        .eq('id', businessId)
        .single();

    await _client
        .from('profiles')
        .update({'role': 'owner'})
        .eq('id', business['owner_id']);

    await _client
        .from('businesses')
        .update({'approval_status': 'approved', 'status': 'open'})
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

  Future<List<Map<String, dynamic>>> getUpdateRequests() async {
    final response = await _client
        .from('business_update_requests')
        .select()
        .order('created_at', ascending: false);

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

  Stream<List<Map<String, dynamic>>> watchBusinesses(String status) {
    return _client.from('businesses').stream(primaryKey: ['id']).map((data) {
      var result = data.where((b) => b['approval_status'] == 'approved');

      if (status != 'all') {
        result = result.where((b) => b['status'] == status);
      }

      return result.map((e) => Map<String, dynamic>.from(e)).toList();
    });
  }

  Future<void> updateAvatar(int index) async {
    final user = _client.auth.currentUser;

    if (user == null) return;

    await _client
        .from('profiles')
        .update({'avatar_index': index})
        .eq('id', user.id);

    debugPrint("Avatar berhasil diubah menjadi $index");
  }

  Stream<Map<String, dynamic>?> watchProfile() {
    final user = _client.auth.currentUser;

    if (user == null) {
      return Stream.value(null);
    }

    return _client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', user.id)
        .map((data) {
          if (data.isEmpty) return null;

          return data.first;
        });
  }

  Future<List<double>> getWeeklyChart(String businessId) async {
    debugPrint("GET WEEKLY CHART");
    debugPrint("Business ID = $businessId");

    final now = DateTime.now();

    final data = await client
        .from('queues')
        .select('queue_date')
        .eq('business_id', businessId)
        .eq('status', 'completed');

    debugPrint(data.toString());

    List<double> values = List.filled(7, 0);

    for (final item in data) {
      final date = DateTime.parse(item['queue_date']);

      final today = DateTime(now.year, now.month, now.day);
      final itemDay = DateTime(date.year, date.month, date.day);

      final diff = today.difference(itemDay).inDays;

      if (diff >= 0 && diff < 7) {
        values[date.weekday - 1]++;
      }
    }

    debugPrint(values.toString());

    return values;
  }

  Future<List<Map<String, dynamic>>> getWaitingQueues(
    String businessId,
    int sessionNumber,
  ) async {
    final data = await client
        .from('queues')
        .select('queue_number,status')
        .eq('business_id', businessId)
        .eq('queue_date', DateTime.now().toIso8601String().split('T').first)
        .eq('session_number', sessionNumber)
        .eq('status', 'waiting')
        .order('queue_number');

    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<double>> getAdminWeeklyChart() async {
    final now = DateTime.now();

    final weekAgo = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 6));

    final data = await _client
        .from('queues')
        .select('queue_date')
        .gte('queue_date', weekAgo.toIso8601String().split('T').first);

    List<double> values = List.filled(7, 0);

    for (final item in data) {
      final date = DateTime.parse(item['queue_date']);

      values[date.weekday - 1]++;
    }

    return values;
  }
}
