import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

class EmptyHistory extends StatelessWidget {
  const EmptyHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_toggle_off,
            size: 90,
            color: AppColors.primary.withValues(alpha: .4),
          ),

          const SizedBox(height: 20),

          Text("Belum Ada Riwayat", style: AppTextStyles.heading2),

          const SizedBox(height: 8),

          Text(
            "Riwayat antrean akan muncul di sini.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}
