import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadow.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

import 'status_badge.dart';

class DetailBanner extends StatelessWidget {
  final String name;
  final String status;
  final String? logoUrl;

  const DetailBanner({
    super.key,
    required this.name,
    required this.status,
    required this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,

      width: double.infinity,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        image: logoUrl != null
            ? DecorationImage(image: NetworkImage(logoUrl!), fit: BoxFit.cover)
            : null,
        gradient: logoUrl == null
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, Color(0xff8B5CF6)],
              )
            : null,
        boxShadow: AppShadow.soft,
      ),

      child: Stack(
        children: [
          if (logoUrl == null)
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                Icons.storefront,
                size: 150,
                color: Colors.white.withValues(alpha: .08),
              ),
            ),
          if (logoUrl != null)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  color: Colors.black.withValues(alpha: 0.35),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.end,

              children: [
                Text(
                  name,
                  style: AppTextStyles.heading2.copyWith(color: Colors.white),
                ),

                const SizedBox(height: 12),

                StatusBadge(status: status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
