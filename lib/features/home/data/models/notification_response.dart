import 'package:team_project_front/features/home/data/models/notification.dart';

import 'package:json_annotation/json_annotation.dart';

part 'notification_response.g.dart';

@JsonSerializable()
class NotificationResponse {
  final List<NotificationItem> content;
  final int? nextCursor;
  final bool hasNext;

  NotificationResponse({
    required this.content,
    required this.nextCursor,
    required this.hasNext,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResponseToJson(this);
}
