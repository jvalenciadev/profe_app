// lib/widgets/checkbox_widget.dart
import 'package:flutter/material.dart';

class CheckboxWidget extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool?> onChanged;

  CheckboxWidget({
    required this.text,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}