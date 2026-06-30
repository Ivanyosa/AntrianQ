import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final int avatarIndex;
  final VoidCallback onTap;

  const ProfileAvatar({
    super.key,
    required this.avatarIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 52,
            backgroundImage: AssetImage(
              "assets/profile/avatar$avatarIndex.webp",
            ),
          ),

          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
