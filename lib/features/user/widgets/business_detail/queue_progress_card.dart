import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadow.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

class QueueProgressCard extends StatelessWidget {
  final int currentQueue;
  final int maxQueue;

  const QueueProgressCard({
    super.key,
    required this.currentQueue,
    required this.maxQueue,
  });

  @override
  Widget build(BuildContext context) {
    final progress = maxQueue == 0
        ? 0.0
        : (currentQueue / maxQueue).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadow.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Progress Antrean Hari Ini", style: AppTextStyles.heading3),

          const SizedBox(height: 18),

          Row(
            children: [
              const Icon(Icons.confirmation_number, color: AppColors.primary),

              const SizedBox(width: 8),

              Text("$currentQueue / $maxQueue", style: AppTextStyles.heading2),
            ],
          ),

          const SizedBox(height: 20),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),

          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${(progress * 100).toStringAsFixed(0)}%",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
