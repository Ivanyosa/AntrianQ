import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../auth/pages/login_page.dart';
import '../../user/providers/queue_provider.dart';

import '../widgets/header/admin_header.dart';
import '../widgets/stats/admin_stat_card.dart';
import '../widgets/search/admin_search.dart';
import '../widgets/search/admin_filter.dart';
import '../widgets/business/approval_card.dart';
import '../widgets/update/update_request_card.dart';

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
      ref.read(queueProvider).getBusinesses(),
      ref.read(queueProvider).getUpdateRequests(),
    ]);
  }

  final searchController = TextEditingController();

  String selectedFilter = "Semua";
  String keyword = "";

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
    searchController.dispose();
    ref
        .read(queueProvider)
        .client
        .removeChannel(ref.read(queueProvider).client.getChannels().first);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: FutureBuilder(
        future: adminFuture,

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = snapshot.data![0] as Map<String, int>;

          final businesses = snapshot.data![1] as List<Map<String, dynamic>>;
          debugPrint("Business count: ${businesses.length}");
          debugPrint(businesses.toString());

          final updateRequests =
              snapshot.data![2] as List<Map<String, dynamic>>;
          debugPrint("Update count: ${updateRequests.length}");

          final pendingCount =
              businesses
                  .where((e) => e['approval_status'] == "pending")
                  .length +
              updateRequests.where((e) => e['status'] == "pending").length;

          var filteredBusinesses = businesses.where((business) {
            final name = (business['name'] ?? '').toString().toLowerCase();

            return name.contains(keyword.toLowerCase());
          }).toList();

          if (selectedFilter != "Semua") {
            filteredBusinesses = filteredBusinesses.where((business) {
              debugPrint("Keyword = $keyword");
              debugPrint("Filtered = ${filteredBusinesses.length}");
              return (business['approval_status'] ?? '')
                      .toString()
                      .toLowerCase() ==
                  selectedFilter.toLowerCase();
            }).toList();
          }
          var filteredUpdates = updateRequests.where((request) {
            final payload = Map<String, dynamic>.from(request['payload']);

            final name = (payload['name'] ?? '').toString().toLowerCase();

            return name.contains(keyword.toLowerCase());
          }).toList();

          if (selectedFilter != "Semua") {
            filteredUpdates = filteredUpdates.where((request) {
              return (request['status'] ?? '').toString().toLowerCase() ==
                  selectedFilter.toLowerCase();
            }).toList();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdminHeader(
                  username: "Admin",
                  pendingCount: pendingCount,
                  todayQueues: stats['todayQueues'] ?? 0,
                ),

                const SizedBox(height: 25),

                Row(
                  children: [
                    Expanded(
                      child: AdminStatCard(
                        icon: Icons.people,
                        title: "User",
                        value: stats['users'].toString(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: AdminStatCard(
                        icon: Icons.store,
                        title: "Usaha",
                        value: stats['businesses'].toString(),
                      ),
                    ),

                    const SizedBox(width: 12),
                  ],
                ),
                const SizedBox(height: 24),

                AdminSearch(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      keyword = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                AdminFilter(
                  selected: selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value;
                    });
                  },
                ),
                const Text(
                  "Persetujuan Admin",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                if (filteredUpdates.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("Tidak ada pengajuan edit"),
                    ),
                  ),

                ...filteredUpdates.map((request) {
                  final payload = Map<String, dynamic>.from(request['payload']);

                  return UpdateRequestCard(
                    status: request['status'],
                    businessName: request['business_name'] ?? "-",
                    ownerName: request['owner_name'] ?? "-",
                    changedField: payload.keys.join(", "),
                    submittedAt: request['created_at'] ?? "-",

                    onDetail: () {
                      // nanti kita buat dialog detail perubahan
                    },

                    onApprove: () async {
                      await ref
                          .read(queueProvider)
                          .approveUpdateRequest(request['id'].toString());

                      if (mounted) {
                        setState(loadData);
                      }
                    },

                    onReject: () async {
                      await ref
                          .read(queueProvider)
                          .rejectUpdateRequest(request['id'].toString());

                      if (mounted) {
                        setState(loadData);
                      }
                    },
                  );
                }),

                if (filteredBusinesses.isEmpty) const Card(),

                ...filteredBusinesses
                    .where((e) {
                      if (selectedFilter == "Pending") {
                        return e['approval_status'] == "pending";
                      }

                      if (selectedFilter == "Approved") {
                        return e['approval_status'] == "approved";
                      }

                      if (selectedFilter == "Rejected") {
                        return e['approval_status'] == "rejected";
                      }

                      return true;
                    })
                    .map((business) {
                      return ApprovalCard(
                        businessName: business['name'] ?? "-",
                        ownerName: business['profiles']?['username'] ?? "-",
                        location: business['location'] ?? "-",

                        onDetail: () {
                          // nanti kita buat dialog detail usaha
                        },

                        onApprove: () async {
                          await ref
                              .read(queueProvider)
                              .approveBusiness(business['id'].toString());

                          if (mounted) {
                            setState(loadData);
                          }
                        },

                        onReject: () async {
                          await ref
                              .read(queueProvider)
                              .rejectBusiness(business['id'].toString());

                          if (mounted) {
                            setState(loadData);
                          }
                        },
                      );
                    }),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
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
            ),
          );
        },
      ),
    );
  }
}
