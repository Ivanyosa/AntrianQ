import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadow.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

class HistoryCard extends StatelessWidget {
  final String businessName;
  final int queueNumber;
  final DateTime createdAt;
  final String status;

  const HistoryCard({
    super.key,
    required this.businessName,
    required this.queueNumber,
    required this.createdAt,
    required this.status,
  });

  Color get badgeColor {
    switch (status) {
      case "completed":
        return Colors.green;

      case "cancelled":
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  String get badgeText {
    switch (status) {
      case "completed":
        return "COMPLETE";

      case "cancelled":
        return "CANCELLED";

      default:
        return status.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadow.soft,
      ),

      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withValues(alpha: .08),
            child: const Icon(Icons.store, color: AppColors.primary),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(businessName, style: AppTextStyles.heading3),

                const SizedBox(height: 6),

                Text(
                  "${createdAt.day}/${createdAt.month}/${createdAt.year}",
                  style: AppTextStyles.bodySmall,
                ),

                const SizedBox(height: 10),

                Text(
                  "Nomor A-${queueNumber.toString().padLeft(3, "0")}",
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(30),
            ),

            child: Text(
              badgeText,
              style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
