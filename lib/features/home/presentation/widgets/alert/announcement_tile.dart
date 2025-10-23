import 'package:flutter/material.dart';
import 'package:team_project_front/core/const/colors.dart';
import 'package:team_project_front/features/home/domain/entities/alert_entity.dart';
import 'package:team_project_front/features/homecam/util/format_relative_time.dart';

class AnnouncementTile extends StatelessWidget {
  const AnnouncementTile({super.key, required this.alert});
  final AlertEntity alert;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3.4),
      leading: alert.pinned
          ? const Icon(Icons.campaign, color: MAIN_COLOR)
          : const Icon(Icons.event_available, color: MAIN_COLOR),
      title: Text(
        alert.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(alert.content, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Text(
            formatRelativeTime(alert.createdAt),
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
