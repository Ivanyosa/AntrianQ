import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

class HomeSearch extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const HomeSearch({super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,

      decoration: InputDecoration(
        hintText: "Cari Usaha...",
        hintStyle: AppTextStyles.bodyMedium,

        prefixIcon: const Icon(Icons.search),

        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          borderSide: BorderSide(color: AppColors.border),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
