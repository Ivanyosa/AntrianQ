import 'package:flutter/material.dart';

import 'history_card.dart';

class HistoryList extends StatelessWidget {
  final List<Map<String, dynamic>> histories;

  const HistoryList({super.key, required this.histories});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: histories.length,

      itemBuilder: (context, index) {
        final history = histories[index];

        final business = history['businesses'];

        return HistoryCard(
          businessName: business['name'] ?? "-",
          queueNumber: history['queue_number'],
          createdAt: DateTime.parse(history['created_at']),
          status: history['status'],
        );
      },
    );
  }
}
