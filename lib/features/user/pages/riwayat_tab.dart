import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/queue_provider.dart';

class RiwayatTab extends ConsumerWidget {
  const RiwayatTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ref.read(queueProvider).getQueueHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Terjadi kesalahan:\n${snapshot.error}"));
        }

        final histories = snapshot.data ?? [];

        if (histories.isEmpty) {
          return const Center(child: Text("Belum ada riwayat antrian"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: histories.length,
          itemBuilder: (context, index) {
            final history = histories[index];

            final business = history['businesses'];

            final status = history['status'].toString();

            Color statusColor;

            switch (status) {
              case 'completed':
                statusColor = Colors.green;
                break;

              case 'cancelled':
                statusColor = Colors.orange;
                break;

              default:
                statusColor = Colors.red;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(history['queue_number'].toString()),
                ),

                title: Text(business['name'] ?? '-'),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tanggal: ${DateTime.parse(history['created_at']).toLocal()}",
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Status: ${status.toUpperCase()}",
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
