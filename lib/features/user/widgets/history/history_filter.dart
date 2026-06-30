import 'package:flutter/material.dart';

class HistoryFilter extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const HistoryFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip("all"),
        const SizedBox(width: 10),
        _chip("completed"),
        const SizedBox(width: 10),
        _chip("cancelled"),
      ],
    );
  }

  Widget _chip(String value) {
    final active = selected == value;

    return Builder(
      builder: (context) {
        return ChoiceChip(
          label: Text(
            value == "all"
                ? "All"
                : value == "completed"
                ? "Complete"
                : "Cancelled",
          ),
          selected: active,
          onSelected: (_) => onChanged(value),
        );
      },
    );
  }
}
