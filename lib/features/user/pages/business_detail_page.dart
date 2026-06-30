import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadow.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/widgets/primary_button.dart';

import '../providers/queue_provider.dart';

import '../widgets/business_detail/detail_header.dart';
import '../widgets/business_detail/business_stat_card.dart';
import '../widgets/business_detail/queue_progress_card.dart';

class BusinessDetailPage extends ConsumerStatefulWidget {
  final String businessId;
  final String title;
  final String location;
  final String description;
  final int serviceDuration;
  final int currentQueue;
  final String status;
  final int maxDailyQueue;
  final String? logoUrl;

  const BusinessDetailPage({
    super.key,
    required this.businessId,
    required this.title,
    required this.location,
    required this.description,
    required this.serviceDuration,
    required this.currentQueue,
    required this.status,
    required this.maxDailyQueue,
    required this.logoUrl,
  });

  @override
  ConsumerState<BusinessDetailPage> createState() => _BusinessDetailPageState();
}

class _BusinessDetailPageState extends ConsumerState<BusinessDetailPage> {
  bool loading = false;
  Future<void> takeQueue() async {
    debugPrint("=== TAKE QUEUE DITEKAN ===");
    setState(() {
      loading = true;
    });

    try {
      final number = await ref.read(queueProvider).takeQueue(widget.businessId);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Nomor antrean Anda $number")));

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst("Exception: ", ""))),
      );
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Color get statusColor {
    switch (widget.status) {
      case "open":
        return AppColors.open;
      case "break":
        return AppColors.breakTime;
      default:
        return AppColors.closed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(title: const Text("Detail Usaha")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            DetailHeader(
              business: {
                'name': widget.title,
                'status': widget.status,
                'logo_url': widget.logoUrl,
              },
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: AppShadow.soft,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Deskrpsi", style: AppTextStyles.heading3),

                  const SizedBox(height: 10),

                  Text(widget.description, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: BusinessStatCard(
                    icon: Icons.schedule,
                    title: "Durasi",
                    value: "${widget.serviceDuration} Menit",
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: BusinessStatCard(
                    icon: Icons.people,
                    title: "Nomor Saat Ini",
                    value: widget.currentQueue.toString(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            QueueProgressCard(
              currentQueue: widget.currentQueue,
              maxQueue: widget.maxDailyQueue,
            ),

            const SizedBox(height: 30),

            PrimaryButton(
              text: "Ambil Antrian",
              loading: loading,
              icon: Icons.confirmation_number,
              onPressed: widget.status == "open" ? takeQueue : null,
            ),
          ],
        ),
      ),
    );
  }
}
