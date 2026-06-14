import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'owner_edit_business_page.dart';

import '../../user/providers/queue_provider.dart';

class OwnerDashboardPage extends ConsumerStatefulWidget {
  const OwnerDashboardPage({super.key});

  @override
  ConsumerState<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends ConsumerState<OwnerDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Owner")),
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: ref.read(queueProvider).watchMyBusiness(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final business = snapshot.data;

          if (business == null) {
            return const Center(child: Text("Usaha belum disetujui admin"));
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    title: Text(business['name']),
                    subtitle: Text("Status: ${business['status']}"),
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  child: ListTile(
                    title: const Text("Nomor Saat Ini"),
                    trailing: Text(
                      business['current_queue'].toString(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: business['status'] != 'open'
                        ? null
                        : () async {
                            try {
                              final next = await ref
                                  .read(queueProvider)
                                  .nextQueue(business['id'].toString());

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Sekarang melayani nomor $next",
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                    child: const Text("NEXT"),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await ref
                              .read(queueProvider)
                              .openBusiness(business['id'].toString());

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Usaha dibuka")),
                            );
                          }
                        },
                        child: const Text("OPEN"),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await ref
                              .read(queueProvider)
                              .setBreakStatus(business['id'].toString());

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Usaha istirahat")),
                            );
                          }
                        },
                        child: const Text("BREAK"),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await ref
                              .read(queueProvider)
                              .closeBusiness(business['id'].toString());

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Usaha ditutup")),
                            );
                          }
                        },
                        child: const Text("CLOSED"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text("EDIT USAHA"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              OwnerEditBusinessPage(business: business),
                        ),
                      );
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
