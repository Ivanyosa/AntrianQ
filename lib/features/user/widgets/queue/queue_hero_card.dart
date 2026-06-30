import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadow.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

class QueueHeroCard extends StatelessWidget {
  final String businessName;
  final int myNumber;
  final int currentNumber;
  final int remaining;
  final int estimation;

  const QueueHeroCard({
    super.key,
    required this.businessName,
    required this.myNumber,
    required this.currentNumber,
    required this.remaining,
    required this.estimation,
  });

  @override
  Widget build(BuildContext context) {
    final progress = ((currentNumber / myNumber).clamp(0.0, 1.0) * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadow.soft,
      ),
      child: Column(
        children: [
          Text(
            businessName,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
          ),

          const SizedBox(height: 8),

          Text(
            "Nomor Antrian",
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
          ),

          const SizedBox(height: 10),

          Text(
            "A-${myNumber.toString().padLeft(3, '0')}",
            style: const TextStyle(
              fontSize: 52,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          const Divider(color: Colors.white24),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  title: "Nomor Saat Ini",
                  value: "A-${currentNumber.toString().padLeft(3, '0')}",
                ),
              ),
              Expanded(
                child: _InfoItem(title: "Estimasi", value: "$estimation Menit"),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _InfoItem(title: "Sisa", value: "$remaining Orang"),
              ),
              Expanded(
                child: _InfoItem(title: "Progress", value: "$progress%"),
              ),
            ],
          ),

          const SizedBox(height: 22),

          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 10,
              color: Colors.white,
              backgroundColor: Colors.white24,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
