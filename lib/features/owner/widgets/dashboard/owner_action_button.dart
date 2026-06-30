import 'package:flutter/material.dart';

class OwnerActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const OwnerActionButton({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: onTap,
      label: Text(text),
    );
  }
}
