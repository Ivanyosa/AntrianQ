import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/queue_provider.dart';
import '../home/business_card.dart';

class BusinessList extends ConsumerWidget {
  final String selectedStatus;
  final String keyword;

  const BusinessList({
    super.key,
    required this.selectedStatus,
    required this.keyword,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: ref.read(queueProvider).watchBusinesses(selectedStatus),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Terjadi kesalahan:\n${snapshot.error}",
              textAlign: TextAlign.center,
            ),
          );
        }

        final businesses = (snapshot.data ?? []).where((business) {
          final name = business['name'].toString().toLowerCase();

          return name.contains(keyword.toLowerCase());
        }).toList();

        if (businesses.isEmpty) {
          return const Center(child: Text("Belum ada usaha tersedia"));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: businesses.length,
          itemBuilder: (context, index) {
            final business = businesses[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: BusinessCard(
                businessId: business['id'].toString(),
                title: business['name'] ?? '-',
                logoUrl: business['logo_url'],
                location: business['location'] ?? '-',
                description: business['description'] ?? '',
                serviceDuration: business['service_duration'] ?? 0,
                currentQueue: business['current_queue'] ?? 0,
                maxDailyQueue: business['max_daily_queue'] ?? 0,
                status: business['status'] ?? 'closed',
              ),
            );
          },
        );
      },
    );
  }
}
