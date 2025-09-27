// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_condition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomCondition _$RoomConditionFromJson(Map<String, dynamic> json) =>
    RoomCondition(
      airTemperature: (json['temperature'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$RoomConditionToJson(RoomCondition instance) =>
    <String, dynamic>{
      'temperature': instance.airTemperature,
      'humidity': instance.humidity,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
