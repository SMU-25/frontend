import 'package:flutter/material.dart';

class NotificationChip extends StatelessWidget {
  const NotificationChip({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = text.contains('체온')
        ? Colors.redAccent
        : text.contains('습도')
        ? Colors.blueAccent
        : Colors.orangeAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.grey.shade300),
        color: backgroundColor.withValues(alpha: 0.08),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: backgroundColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
