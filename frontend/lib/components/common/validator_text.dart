import 'package:flutter/material.dart';

class ValidatorText extends StatelessWidget {
  final String text;
  final Color? color;
  const ValidatorText({
    super.key,
    this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
      child: Text(
        text,
        style: TextStyle(color: color ?? const Color(0xffe32222)),
      ),
    );
  }
}
