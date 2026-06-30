import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/theme/app_colors.dart';

class HistoryStats extends StatelessWidget {
  final int total;
  final int completed;

  const HistoryStats({super.key, required this.total, required this.completed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: "TOTAL HISTORY",
            value: total.toString(),
            valueColor: AppColors.primary,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: _StatCard(
            title: "COMPLETED",
            value: completed.toString(),
            valueColor: Colors.green,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xffF7F5FF),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.primary.withValues(alpha: .10)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 1,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
