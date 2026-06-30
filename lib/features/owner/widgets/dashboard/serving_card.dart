import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadow.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

class ServingCard extends StatelessWidget {
  final int currentQueue;
  final VoidCallback onNext;

  const ServingCard({
    super.key,
    required this.currentQueue,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadow.soft,
      ),

      child: Column(
        children: [
          Text("SEDANG DILAYANI", style: AppTextStyles.bodyMedium),

          const SizedBox(height: 18),

          Text(
            "A-$currentQueue",
            style: AppTextStyles.displayLarge.copyWith(
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 10),

          const Text("Nomor Saat Ini"),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onNext,
              icon: const Icon(Icons.skip_next),
              label: const Text("NEXT"),
            ),
          ),
        ],
      ),
    );
  }
}
