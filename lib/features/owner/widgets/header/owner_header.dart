import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_style.dart';

class OwnerHeader extends StatelessWidget {
  final String username;
  final int avatarIndex;

  const OwnerHeader({
    super.key,
    required this.username,
    required this.avatarIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Dashboard Owner", style: AppTextStyles.bodyMedium),

              const SizedBox(height: 4),

              Text(username, style: AppTextStyles.displayMedium),
            ],
          ),
        ),

        CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage("assets/profile/avatar$avatarIndex.webp"),
        ),
      ],
    );
  }
}
