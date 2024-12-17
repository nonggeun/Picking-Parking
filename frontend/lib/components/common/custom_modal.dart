import 'package:flutter/material.dart';
import 'button.dart';

class CustomModal extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const CustomModal({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: const Color(0xFFF6F6F6),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (onCancel != null)
                  Button(
                    text: "취소",
                    onPressed: onCancel!,
                    horizontal: 6,
                    vertical: 8,
                    fontSize: 16,
                    backgroundColor: Colors.grey,
                  ),
                Button(
                  text: "확인",
                  onPressed: onConfirm,
                  horizontal: 6,
                  vertical: 8,
                  fontSize: 16,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
