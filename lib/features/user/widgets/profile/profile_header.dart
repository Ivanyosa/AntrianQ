import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_style.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const ProfileHeader({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name, style: AppTextStyles.heading2),

        const SizedBox(height: 6),

        Text(email, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}
