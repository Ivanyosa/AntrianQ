import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadow.dart';
// import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

class UpdateRequestCard extends StatelessWidget {
  final String businessName;
  final String ownerName;
  final String changedField;
  final String submittedAt;

  final VoidCallback onDetail;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  final String status;

  const UpdateRequestCard({
    super.key,
    required this.businessName,
    required this.ownerName,
    required this.changedField,
    required this.submittedAt,
    required this.onDetail,
    required this.onApprove,
    required this.onReject,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String badgeText;

    switch (status) {
      case "approved":
        badgeColor = Colors.green;
        badgeText = "APPROVED";
        break;

      case "rejected":
        badgeColor = Colors.red;
        badgeText = "REJECTED";
        break;

      default:
        badgeColor = Colors.orange;
        badgeText = "REQUEST";
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadow.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.edit_document,
                  color: Colors.blue,
                  size: 30,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(businessName, style: AppTextStyles.heading3),

                    const SizedBox(height: 4),

                    Text(ownerName, style: AppTextStyles.bodyMedium),

                    const SizedBox(height: 4),

                    Text(
                      "Mengubah : $changedField",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: badgeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              const Icon(Icons.schedule, size: 18, color: Colors.grey),

              const SizedBox(width: 8),

              Text(submittedAt, style: AppTextStyles.bodySmall),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onDetail,
              icon: const Icon(Icons.visibility),
              label: const Text("Lihat Perubahan"),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onReject,
                  icon: const Icon(Icons.close),
                  label: const Text("Reject"),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: FilledButton.icon(
                  onPressed: onApprove,
                  icon: const Icon(Icons.check),
                  label: const Text("Approve"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
