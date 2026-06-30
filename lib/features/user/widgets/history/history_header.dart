import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_style.dart';

class HistoryHeader extends StatelessWidget {
  const HistoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Riwayat", style: AppTextStyles.heading1),

        const SizedBox(height: 6),

        Text(
          "Semua antrean yang pernah kamu ambil",
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}
