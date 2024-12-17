import 'package:flutter/material.dart';

class SwitchButton extends StatefulWidget {
  const SwitchButton({super.key});

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  bool light = true;
  @override
  Widget build(BuildContext context) {
    return Switch(
        activeColor: Colors.white,
        activeTrackColor: Theme.of(context).primaryColor,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: Colors.grey[300],
        value: light,
        onChanged: (bool value) {
          setState(() {
            light = value;
          });
        });
  }
}
