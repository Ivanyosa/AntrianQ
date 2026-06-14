import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/queue_provider.dart';

class AntrianTab extends ConsumerWidget {
  const AntrianTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(queueProvider).getMyQueue(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const Center(
            child: Text(
              "Anda belum mengambil antrian",
            ),
          );
        }

        final queue = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                "Nomor Antrian Saya",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  queue['queue_number'],
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              ListTile(
                title: const Text("Status"),
                subtitle: Text(queue['status']),
              ),

              ListTile(
                title: const Text("Layanan"),
                subtitle: Text(
                  queue['services']['name'],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}