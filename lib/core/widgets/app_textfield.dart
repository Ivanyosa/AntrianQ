import 'package:flutter/material.dart';

import '../constants/app_radius.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    this.controller,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyLarge,

      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium,

        prefixIcon: Icon(prefixIcon, color: AppColors.textSecondary),

        suffixIcon: suffixIcon,

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          borderSide: BorderSide(color: AppColors.border),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          borderSide: const BorderSide(color: AppColors.danger),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
      ),
    );
  }
}
