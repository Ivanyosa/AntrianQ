import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';

class RegisterLink extends StatelessWidget {
  final VoidCallback onTap;

  const RegisterLink({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?", style: AppTextStyles.bodyMedium),

        GestureDetector(
          onTap: onTap,

          child: const Padding(
            padding: EdgeInsets.only(left: 4),

            child: Text(
              "Register",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
