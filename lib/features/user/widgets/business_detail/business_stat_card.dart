import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadow.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

class BusinessStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const BusinessStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadow.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 28),

          const SizedBox(height: 14),

          Text(value, style: AppTextStyles.heading2),

          const SizedBox(height: 4),

          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
