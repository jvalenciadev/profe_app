// lib/widgets/description_text.dart
import 'package:flutter/material.dart';

class DescriptionText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  DescriptionText({required this.text, this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      textAlign: textAlign,
    );
  }
}
