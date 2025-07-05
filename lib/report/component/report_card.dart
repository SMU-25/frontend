import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class ReportCard extends StatelessWidget {
  final String createdAt;
  final String content;
  final VoidCallback? onEditPressed;

  const ReportCard({
    super.key,
    required this.createdAt,
    required this.content,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 48,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: MAIN_COLOR,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  createdAt,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEditPressed ?? () {},
            icon: Icon(
              Icons.edit_calendar,
              color: MAIN_COLOR,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
