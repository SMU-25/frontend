import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class NotificationItem {
  final int notificationId;
  final String type;
  final String message;
  final double? fever;
  final double? temperature;
  final double? humidity;
  final DateTime createdAt;
  final String childName;
  final bool read;

  NotificationItem({
    required this.notificationId,
    required this.type,
    required this.message,
    this.fever,
    this.temperature,
    this.humidity,
    required this.createdAt,
    required this.childName,
    required this.read,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationItemToJson(this);
}
