import 'package:team_project_front/home/model/notification.dart';

class NotificationResponse {
  final List<NotificationItem> content;
  final int? nextCursor;
  final bool hasNext;

  NotificationResponse({
    required this.content,
    required this.nextCursor,
    required this.hasNext,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      content:
          (json['content'] as List<dynamic>)
              .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
              .toList(),
      nextCursor: (json['nextCursor'] as num?)?.toInt(),
      hasNext: json['hasNext'] as bool? ?? false,
    );
  }
}
