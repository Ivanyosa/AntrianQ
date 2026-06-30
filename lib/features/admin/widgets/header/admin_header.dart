import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadow.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

class AdminHeader extends StatelessWidget {
  final String username;
  final int pendingCount;
  final int todayQueues;

  const AdminHeader({
    super.key,
    required this.username,
    required this.pendingCount,
    required this.todayQueues,
  });

  String get today {
    const days = [
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jumat",
      "Sabtu",
      "Minggu",
    ];

    const months = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];

    final now = DateTime.now();

    return "${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadow.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.admin_panel_settings_rounded,
                  color: AppColors.primary,
                  size: 34,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selamat Datang",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(username, style: AppTextStyles.heading2),

                    const SizedBox(height: 6),

                    Text(
                      today,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.notifications_active,
                      color: Colors.orange,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "$pendingCount Pending",
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hari Ini",
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(
                      Icons.confirmation_number,
                      color: Colors.blue,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$todayQueues Antrian dibuat",
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.pending_actions,
                      color: Colors.orange,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$pendingCount Approval menunggu",
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
