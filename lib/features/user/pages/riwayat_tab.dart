import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/queue_provider.dart';

import '../widgets/history/history_header.dart';
import '../widgets/history/history_stats.dart';
import '../widgets/history/history_filter.dart';
import '../widgets/history/history_list.dart';
import '../widgets/history/empty_history.dart';

class RiwayatTab extends ConsumerStatefulWidget {
  const RiwayatTab({super.key});

  @override
  ConsumerState<RiwayatTab> createState() => _RiwayatTabState();
}

class _RiwayatTabState extends ConsumerState<RiwayatTab> {
  String selectedFilter = "all";
  late Future<List<Map<String, dynamic>>> historyFuture;
  @override
  void initState() {
    super.initState();

    historyFuture = ref.read(queueProvider).getQueueHistory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Terjadi kesalahan:\n${snapshot.error}"));
        }

        final histories = snapshot.data ?? [];
        List<Map<String, dynamic>> filtered = histories;

        if (selectedFilter != "all") {
          filtered = histories
              .where((e) => e['status'] == selectedFilter)
              .toList();
        }

        final completed = histories
            .where((e) => e['status'] == 'completed')
            .length;

        if (histories.isEmpty) {
          return const EmptyHistory();
        }

        return Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              const HistoryHeader(),

              const SizedBox(height: 20),

              HistoryStats(total: histories.length, completed: completed),

              const SizedBox(height: 20),

              HistoryFilter(
                selected: selectedFilter,
                onChanged: (value) {
                  setState(() {
                    selectedFilter = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              Expanded(
                child: filtered.isEmpty
                    ? const EmptyHistory()
                    : HistoryList(histories: filtered),
              ),
            ],
          ),
        );
      },
    );
  }
}
