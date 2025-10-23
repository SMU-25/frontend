// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationItem _$NotificationItemFromJson(Map<String, dynamic> json) =>
    NotificationItem(
      notificationId: (json['notificationId'] as num).toInt(),
      type: json['type'] as String,
      message: json['message'] as String,
      fever: (json['fever'] as num?)?.toDouble(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      childName: json['childName'] as String,
      read: json['read'] as bool,
    );

Map<String, dynamic> _$NotificationItemToJson(NotificationItem instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'type': instance.type,
      'message': instance.message,
      'fever': instance.fever,
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'createdAt': instance.createdAt.toIso8601String(),
      'childName': instance.childName,
      'read': instance.read,
    };
