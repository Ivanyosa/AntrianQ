import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadow.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

class QueueBottomInfo extends StatelessWidget {
  final int estimation;
  final String serviceName;

  const QueueBottomInfo({
    super.key,
    required this.estimation,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context) {
    final estimatedTime = DateTime.now().add(Duration(minutes: estimation));

    String hour =
        "${estimatedTime.hour.toString().padLeft(2, '0')}:${estimatedTime.minute.toString().padLeft(2, '0')}";

    return Row(
      children: [
        Expanded(
          child: _CardItem(
            icon: Icons.schedule,
            title: "Estimasi Dipanggil",
            value: hour,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: _CardItem(
            icon: Icons.store,
            title: "Layanan",
            value: serviceName,
          ),
        ),
      ],
    );
  }
}

class _CardItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _CardItem({
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
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadow.soft,
      ),

      child: Column(
        children: [
          Icon(icon, size: 32, color: AppColors.primary),

          const SizedBox(height: 12),

          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),

          const SizedBox(height: 8),

          Text(
            value,
            textAlign: TextAlign.center,
            style: AppTextStyles.heading3,
          ),
        ],
      ),
    );
  }
}
