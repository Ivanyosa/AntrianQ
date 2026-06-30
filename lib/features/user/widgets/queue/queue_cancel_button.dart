import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';

class QueueCancelButton extends StatelessWidget {
  final VoidCallback onPressed;

  const QueueCancelButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,

      child: OutlinedButton.icon(
        onPressed: onPressed,

        icon: const Icon(Icons.close, color: Colors.red),

        label: const Text(
          "Batalkan Antrian",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),

        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),

          side: const BorderSide(color: Colors.red, width: 1.4),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
        ),
      ),
    );
  }
}
