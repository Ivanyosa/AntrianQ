import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/queue_provider.dart';

import '../widgets/queue/queue_hero_card.dart';
import '../widgets/queue/queue_bottom_info.dart';
import '../widgets/queue/queue_cancel_button.dart';
import '../widgets/queue/empty_queue.dart';
import '../widgets/queue/queue_progress_card.dart';

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
          return const EmptyQueue();
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

              const SizedBox(height: 24),

              QueueHeroCard(
                businessName: business['name'],
                myNumber: myNumber,
                currentNumber: currentNumber,
                remaining: remaining,
                estimation: estimation,
              ),

              const SizedBox(height: 20),

              QueueBottomInfo(
                estimation: estimation,
                serviceName: "General Service",
              ),

              const SizedBox(height: 24),

              QueueProgressCard(
                currentNumber: currentNumber,
                myNumber: myNumber,
              ),
              const SizedBox(height: 30),

              QueueCancelButton(
                onPressed: () async {
                  try {
                    await ref
                        .read(queueProvider)
                        .cancelQueue(queue['id'].toString());

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Antrian berhasil dibatalkan"),
                      ),
                    );
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
