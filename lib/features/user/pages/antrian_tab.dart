import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/queue_provider.dart';

class AntrianTab extends ConsumerWidget {
  const AntrianTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: ref.read(queueProvider).watchMyQueue(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final queue = snapshot.data;

        if (queue == null) {
          return const Center(
            child: Text(
              "Kamu belum memiliki antrian aktif",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        final business = queue['businesses'];

        final myNumber = queue['queue_number'] as int;
        final currentNumber = business['current_queue'] as int;
        final serviceDuration = business['service_duration'] as int;

        final remaining = (myNumber - currentNumber).clamp(0, 9999);

        final estimation = remaining * serviceDuration;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Antrian Saya",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        business['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        myNumber.toString(),
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Text(
                        "Nomor Antrian",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              ListTile(
                leading: const Icon(Icons.confirmation_number),
                title: const Text("Nomor Saat Ini"),
                trailing: Text(currentNumber.toString()),
              ),

              ListTile(
                leading: const Icon(Icons.people),
                title: const Text("Sisa Antrian"),
                trailing: Text(remaining.toString()),
              ),

              ListTile(
                leading: const Icon(Icons.schedule),
                title: const Text("Estimasi"),
                trailing: Text("$estimation menit"),
              ),

              ListTile(
                leading: const Icon(Icons.info),
                title: const Text("Status"),
                trailing: Text(queue['status']),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    try {
                      await ref
                          .read(queueProvider)
                          .cancelQueue(queue['id'].toString());

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Antrian berhasil dibatalkan"),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text("Batalkan Antrian"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
