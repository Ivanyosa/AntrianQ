import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AdminFilter extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const AdminFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ["semua", "pending", "approved", "rejected"];

    return SizedBox(
      height: 42,

      child: ListView.separated(
        scrollDirection: Axis.horizontal,

        itemCount: filters.length,

        separatorBuilder: (_, __) => const SizedBox(width: 10),

        itemBuilder: (_, index) {
          final item = filters[index];

          final active = item == selected;

          return ChoiceChip(
            label: Text(item),

            selected: active,

            onSelected: (_) => onChanged(item),

            selectedColor: AppColors.primary,

            labelStyle: TextStyle(
              color: active ? Colors.white : Colors.black87,
            ),
          );
        },
      ),
    );
  }
}
