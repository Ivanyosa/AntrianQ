import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../auth/providers/profile_provider.dart';
import '../../user/providers/queue_provider.dart';

import '../widgets/header/owner_header.dart';
import '../widgets/dashboard/serving_card.dart';
import '../widgets/dashboard/owner_action_button.dart';
import '../widgets/stats/stat_card.dart';
import '../widgets/chart/weekly_chart.dart';
import '../widgets/queue/waiting_queue_list.dart';

import 'owner_edit_business_page.dart';

class OwnerDashboardPage extends ConsumerWidget {
  const OwnerDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Owner")),

      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(child: Text(e.toString())),

        data: (profileData) {
          return StreamBuilder<Map<String, dynamic>?>(
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

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    OwnerHeader(
                      username: profileData['username'] ?? "Owner",

                      avatarIndex: profileData['avatar_index'] ?? 1,
                    ),

                    const SizedBox(height: 24),

                    ServingCard(
                      currentQueue: business['current_queue'],

                      onNext: () async {
                        try {
                          final result = await ref
                              .read(queueProvider)
                              .nextQueue(business['id'].toString());

                          final number = result['queue_number'];
                          final userId = result['user_id'];

                          try {
                            await Supabase.instance.client.functions.invoke(
                              'send-queue-notification',
                              body: {
                                'user_id': userId,
                                'title': 'Giliran Anda',
                                'body':
                                    'Nomor antrean $number sedang dipanggil.',
                              },
                            );
                          } catch (_) {}

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Sekarang melayani nomor $number",
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: OwnerActionButton(
                            text: "Open",
                            color: Colors.green,
                            onTap: () async {
                              await ref
                                  .read(queueProvider)
                                  .openBusiness(business['id'].toString());
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: OwnerActionButton(
                            text: "Break",
                            color: Colors.orange,
                            onTap: () async {
                              await ref
                                  .read(queueProvider)
                                  .setBreakStatus(business['id'].toString());
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: OwnerActionButton(
                            text: "Close",
                            color: Colors.red,
                            onTap: () async {
                              await ref
                                  .read(queueProvider)
                                  .closeBusiness(business['id'].toString());
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: "Hari Ini",
                            value: business['current_queue'].toString(),
                            icon: Icons.people,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: StatCard(
                            title: "Status",
                            value: business['status'].toString().toUpperCase(),
                            icon: Icons.store,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    FutureBuilder<List<double>>(
                      future: ref
                          .read(queueProvider)
                          .getWeeklyChart(business['id'].toString()),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox(
                            height: 220,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        return WeeklyChart(values: snapshot.data!);
                      },
                    ),

                    const SizedBox(height: 24),
                    Text(
                      "Antrian Menunggu",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(height: 16),

                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: ref
                          .read(queueProvider)
                          .getWaitingQueues(
                            business['id'],
                            business['queue_session'],
                          ),

                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return WaitingQueueList(queues: snapshot.data!);
                      },
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit Usaha"),
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

                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
