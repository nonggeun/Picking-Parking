import 'package:flutter/material.dart';

class InputLabel extends StatelessWidget {
  final String name;
  const InputLabel({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Text(
        name,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}
