import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../auth/pages/login_page.dart';
import '../../user/providers/queue_provider.dart';

class AdminPage extends ConsumerStatefulWidget {
  const AdminPage({super.key});

  @override
  ConsumerState<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage> {
  late Future<List<dynamic>> adminFuture;
  void loadData() {
    adminFuture = Future.wait([
      ref.read(queueProvider).getAdminStats(),
      ref.read(queueProvider).getPendingBusinesses(),
      ref.read(queueProvider).getPendingUpdateRequests(),
    ]);
  }

  @override
  void initState() {
    super.initState();

    loadData();

    final client = ref.read(queueProvider).client;

    client
        .channel('admin-dashboard')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'businesses',
          callback: (_) {
            if (mounted) {
              setState(loadData);
            }
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'business_update_requests',
          callback: (_) {
            if (mounted) {
              setState(loadData);
            }
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'queues',
          callback: (_) {
            if (mounted) {
              setState(loadData);
            }
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    ref
        .read(queueProvider)
        .client
        .removeChannel(ref.read(queueProvider).client.getChannels().first);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: FutureBuilder(
        future: adminFuture,

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = snapshot.data![0] as Map<String, int>;

          final businesses = snapshot.data![1] as List<Map<String, dynamic>>;

          final updateRequests =
              snapshot.data![2] as List<Map<String, dynamic>>;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  title: const Text("Jumlah User"),
                  trailing: Text(stats['users'].toString()),
                ),
              ),

              Card(
                child: ListTile(
                  title: const Text("Jumlah Usaha"),
                  trailing: Text(stats['businesses'].toString()),
                ),
              ),

              Card(
                child: ListTile(
                  title: const Text("Antrian Aktif"),
                  trailing: Text(stats['activeQueues'].toString()),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Pengajuan Edit Usaha",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              if (updateRequests.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Tidak ada pengajuan edit"),
                  ),
                ),

              ...updateRequests.map((request) {
                final payload = Map<String, dynamic>.from(request['payload']);

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request['businesses']['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 8),

                        Text("Lokasi: ${payload['location']}"),

                        Text("Estimasi: ${payload['service_duration']}"),

                        Text("Max Queue: ${payload['max_daily_queue']}"),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await ref
                                      .read(queueProvider)
                                      .approveUpdateRequest(
                                        request['id'].toString(),
                                      );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Edit disetujui"),
                                    ),
                                  );
                                },
                                child: const Text("APPROVE"),
                              ),
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () async {
                                  await ref
                                      .read(queueProvider)
                                      .rejectUpdateRequest(
                                        request['id'].toString(),
                                      );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Edit ditolak"),
                                    ),
                                  );
                                },
                                child: const Text("REJECT"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),

              if (businesses.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Tidak ada pengajuan"),
                  ),
                ),

              ...businesses.map(
                (business) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          business['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        Text(business['location']),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await ref
                                      .read(queueProvider)
                                      .approveBusiness(
                                        business['id'].toString(),
                                      );

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Usaha disetujui"),
                                      ),
                                    );
                                  }
                                },
                                child: const Text("APPROVE"),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () async {
                                  await ref
                                      .read(queueProvider)
                                      .rejectBusiness(
                                        business['id'].toString(),
                                      );

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Usaha ditolak"),
                                      ),
                                    );
                                  }
                                },
                                child: const Text("REJECT"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout Admin"),
                  onPressed: () async {
                    await Supabase.instance.client.auth.signOut();

                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
