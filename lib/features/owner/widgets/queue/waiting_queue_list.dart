import 'package:flutter/material.dart';

import 'waiting_queue_tile.dart';

class WaitingQueueList extends StatelessWidget {
  final List<Map<String, dynamic>> queues;

  const WaitingQueueList({super.key, required this.queues});

  @override
  Widget build(BuildContext context) {
    if (queues.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text("Tidak ada antrean menunggu"),
        ),
      );
    }

    return Column(
      children: queues
          .map(
            (queue) => WaitingQueueTile(
              queueNumber: queue['queue_number'],
              status: queue['status'],
            ),
          )
          .toList(),
    );
  }
}
