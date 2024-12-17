import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Spinner extends StatelessWidget {
  final Color color;
  final double size;
  final Duration duration;

  const Spinner(
      {super.key,
      this.color = Colors.black,
      this.size = 50.0,
      this.duration = const Duration(milliseconds: 1200)});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitThreeBounce(
        color: color,
        size: size,
        duration: duration,
      ),
    );
  }
}
