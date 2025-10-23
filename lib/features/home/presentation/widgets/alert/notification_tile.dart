import 'package:flutter/material.dart';
import 'package:team_project_front/core/const/colors.dart';
import 'package:team_project_front/features/home/domain/entities/notification_entiry.dart';
import 'package:team_project_front/features/home/presentation/widgets/alert/notification_chip.dart';
import 'package:team_project_front/features/homecam/util/format_relative_time.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.item});
  final NotificationItemEntity item;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];

    if (item.fever != null) {
      chips.add(
        NotificationChip(text: '체온 ${item.fever!.toStringAsFixed(1)}℃'),
      );
    }
    if (item.temperature != null) {
      chips.add(
        NotificationChip(text: '방온도 ${item.temperature!.toStringAsFixed(1)}℃'),
      );
    }
    if (item.humidity != null) {
      chips.add(
        NotificationChip(text: '습도 ${item.humidity!.toStringAsFixed(1)}%'),
      );
    }

    return ListTile(
      minVerticalPadding: 12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: Icon(
        Icons.favorite,
        color: item.read ? Colors.grey : MAIN_COLOR,
      ),
      title: Text(
        item.message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16,
          fontWeight: item.read ? FontWeight.normal : FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (chips.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(spacing: 6, runSpacing: -6, children: chips),
          ],
          const SizedBox(height: 10),
          Text(
            '${item.childName} · ${formatRelativeTime(item.createdAt)}',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
