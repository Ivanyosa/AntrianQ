import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

class StatusFilter extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onChanged;

  const StatusFilter({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatusChip(
            title: "All",
            value: "all",
            color: AppColors.primary,
            selected: selectedStatus == "all",
            onTap: () => onChanged("all"),
          ),
        ),

        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatusChip(
            title: "Open",
            value: "open",
            color: AppColors.open,
            selected: selectedStatus == "open",
            onTap: () => onChanged("open"),
          ),
        ),

        const SizedBox(width: AppSpacing.md),

        Expanded(
          child: _StatusChip(
            title: "Break",
            value: "break",
            color: AppColors.breakTime,
            selected: selectedStatus == "break",
            onTap: () => onChanged("break"),
          ),
        ),

        const SizedBox(width: AppSpacing.md),

        Expanded(
          child: _StatusChip(
            title: "Closed",
            value: "closed",
            color: AppColors.closed,
            selected: selectedStatus == "closed",
            onTap: () => onChanged("closed"),
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _StatusChip({
    required this.title,
    required this.value,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),

      height: 48,

      decoration: BoxDecoration(
        color: selected ? color : Colors.white,

        borderRadius: BorderRadius.circular(AppRadius.xxl),

        border: Border.all(color: selected ? color : AppColors.border),

        boxShadow: selected
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.20),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.xxl),

          onTap: onTap,

          child: Center(
            child: Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(
                color: selected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
