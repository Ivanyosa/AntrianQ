import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

class EmptyQueue extends StatelessWidget {
  const EmptyQueue({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              Icons.event_busy_rounded,
              size: 90,
              color: AppColors.primary.withValues(alpha: .4),
            ),

            const SizedBox(height: 24),

            Text("Belum Ada Antrian", style: AppTextStyles.heading2),

            const SizedBox(height: 10),

            Text(
              "Silakan ambil nomor antrean\nmelalui halaman Home.",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
