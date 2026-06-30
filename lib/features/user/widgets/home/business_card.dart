import 'package:flutter/material.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../pages/business_detail_page.dart';

class BusinessCard extends StatelessWidget {
  final String businessId;
  final String title;
  final String location;
  final String description;
  final int serviceDuration;
  final int currentQueue;
  final String status;
  final int maxDailyQueue;
  final String? logoUrl;

  const BusinessCard({
    super.key,
    required this.businessId,
    required this.title,
    required this.location,
    required this.description,
    required this.serviceDuration,
    required this.currentQueue,
    required this.status,
    required this.maxDailyQueue,
    required this.logoUrl,
  });

  Color get statusColor {
    switch (status) {
      case "open":
        return AppColors.open;
      case "break":
        return AppColors.breakTime;
      default:
        return AppColors.closed;
    }
  }

  String get statusText {
    switch (status) {
      case "open":
        return "OPEN";
      case "break":
        return "BREAK";
      default:
        return "CLOSED";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BusinessDetailPage(
              businessId: businessId,
              title: title,
              logoUrl: logoUrl,
              location: location,
              description: description,
              serviceDuration: serviceDuration,
              currentQueue: currentQueue,
              maxDailyQueue: maxDailyQueue,
              status: status,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: logoUrl != null
                    ? Image.network(logoUrl!, fit: BoxFit.cover)
                    : Container(
                        color: AppColors.primary.withValues(alpha: .08),
                        child: const Center(
                          child: Icon(
                            Icons.store,
                            size: 48,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            Text(title, style: AppTextStyles.heading3),

            const SizedBox(height: 6),

            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(location, style: AppTextStyles.bodyMedium),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium,
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 18),
                    const SizedBox(width: 6),
                    Text("$serviceDuration menit"),
                  ],
                ),

                const Spacer(),

                Row(
                  children: [
                    const Icon(Icons.people, size: 18),
                    const SizedBox(width: 6),
                    Text("$currentQueue antrean"),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
