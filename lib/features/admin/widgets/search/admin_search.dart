import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/theme/app_colors.dart';

class AdminSearch extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const AdminSearch({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,

      decoration: InputDecoration(
        hintText: "Cari usaha atau owner...",

        prefixIcon: const Icon(Icons.search),

        filled: true,

        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(vertical: 16),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.round),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.round),
          borderSide: BorderSide(color: AppColors.border),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.round),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
