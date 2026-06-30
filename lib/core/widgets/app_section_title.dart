import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';

class AppSectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onTap;

  const AppSectionTitle({
    super.key,
    required this.title,
    this.action,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.heading2),
        if (action != null)
          GestureDetector(
            onTap: onTap,
            child: Text(
              action!,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
