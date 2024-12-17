import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double horizontal;
  final double vertical;
  final double fontSize;
  final IconData? icon;
  final double? iconSize;
  final double? radius;
  final Color? backgroundColor;
  final Color? contentColor;
  final double? width; // 추가된 속성

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.horizontal = 16.0,
    this.vertical = 12.0,
    required this.fontSize,
    this.icon,
    this.iconSize,
    this.radius,
    this.backgroundColor,
    this.contentColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal),
      child: Container(
        width: width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: onPressed == null
                ? Colors.grey
                : backgroundColor ?? Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 10),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: vertical,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    size: iconSize ?? 15,
                    color: contentColor ?? Colors.white,
                  ),
                Text(
                  text,
                  style: TextStyle(
                    color: contentColor ?? Colors.white,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
