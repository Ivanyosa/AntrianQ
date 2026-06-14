import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/queue_provider.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Halo 👋",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "Selamat datang di AntrianQ",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            const Text(
              "Usaha Tersedia",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: ref.read(queueProvider).watchBusinesses(),
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

                  final businesses = snapshot.data ?? [];

                  if (businesses.isEmpty) {
                    return const Center(
                      child: Text("Belum ada usaha tersedia"),
                    );
                  }

                  return ListView.builder(
                    itemCount: businesses.length,
                    itemBuilder: (context, index) {
                      final business = businesses[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ServiceCard(
                          businessId: business['id'].toString(),
                          title: business['name'] ?? '-',
                          location: business['location'] ?? '-',
                          status: business['status'] ?? 'closed',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends ConsumerWidget {
  final String businessId;
  final String title;
  final String location;
  final String status;

  const ServiceCard({
    super.key,
    required this.businessId,
    required this.title,
    required this.location,
    required this.status,
  });

  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.green;

      case 'break':
        return Colors.orange;

      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(location, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 6),

            Row(
              children: [
                const Text(
                  "Status: ",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: getStatusColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: status.toLowerCase() != 'open'
                    ? null
                    : () async {
                        try {
                          final number = await ref
                              .read(queueProvider)
                              .takeQueue(businessId);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Berhasil mengambil nomor antrian $number',
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.toString().replaceFirst('Exception: ', ''),
                                ),
                              ),
                            );
                          }
                        }
                      },
                child: const Text("Ambil Antrian"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
