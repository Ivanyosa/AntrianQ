import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadow.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

class QueueProgressCard extends StatelessWidget {
  final int currentNumber;
  final int myNumber;

  const QueueProgressCard({
    super.key,
    required this.currentNumber,
    required this.myNumber,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentNumber / myNumber).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadow.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Progress Antrian", style: AppTextStyles.heading3),

          const SizedBox(height: 18),

          LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            borderRadius: BorderRadius.circular(20),
            color: AppColors.primary,
            backgroundColor: Colors.grey.shade200,
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Saat ini : $currentNumber",
                style: AppTextStyles.bodyMedium,
              ),
              Text("Nomor Anda : $myNumber", style: AppTextStyles.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}
