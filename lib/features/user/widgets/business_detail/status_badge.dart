import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;

    IconData icon;

    String text = status.toUpperCase();

    switch (status.toLowerCase()) {
      case 'open':
        color = Colors.green;
        icon = Icons.check_circle;
        break;

      case 'break':
        color = Colors.orange;
        icon = Icons.coffee;
        break;

      case 'closed':
        color = Colors.red;
        icon = Icons.cancel;
        break;

      default:
        color = Colors.grey;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),

          const SizedBox(width: 6),

          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
