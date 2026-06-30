import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_text_style.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.massive),

        Image.asset(AppAssets.logo, width: 150),

        const SizedBox(height: AppSpacing.xxl),

        Text("Create Account", style: AppTextStyles.displayMedium),

        const SizedBox(height: AppSpacing.sm),

        Text(
          "Create your account to start using AntrianQ",
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium,
        ),

        const SizedBox(height: AppSpacing.massive),
      ],
    );
  }
}
