import 'package:flutter/material.dart';
import 'package:team_project_front/homecam/util/format_relative_time.dart';

class StatInfoCard extends StatelessWidget {
  const StatInfoCard({
    super.key,
    required this.title,
    required this.isLoading,
    this.value,
    required this.unit,
    this.timestamp,
    this.icon,
    this.color,
  });

  final String title;
  final bool isLoading;
  final double? value;
  final String unit;
  final DateTime? timestamp;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = color ?? theme.colorScheme.primary;
    final bg = baseColor.withOpacity(0.08);
    final iconBg = baseColor.withOpacity(0.15);

    Widget body;
    if (isLoading) {
      body = const Row(
        children: [
          SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 10),
          Text('불러오는 중…'),
        ],
      );
    } else if (value == null) {
      body = const Text('데이터 없음', style: TextStyle(color: Colors.grey));
    } else {
      body = Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            value!.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
          const SizedBox(width: 6),
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Text(
              unit,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          const Spacer(),
          Text(
            formatRelativeTime(timestamp),
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: baseColor.withValues(alpha: 0.15)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon ?? Icons.info, color: baseColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                body,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
