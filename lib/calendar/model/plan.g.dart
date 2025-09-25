// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Plan _$PlanFromJson(Map<String, dynamic> json) => Plan(
  calendarId: (json['calendarId'] as num).toInt(),
  recordDate: json['recordDate'] as String?,
  date: json['scheduleDate'] == null
      ? null
      : DateTime.parse(json['scheduleDate'] as String),
  title: json['title'] as String,
  content: json['content'] as String,
);

Map<String, dynamic> _$PlanToJson(Plan instance) => <String, dynamic>{
  'calendarId': instance.calendarId,
  'title': instance.title,
  'content': instance.content,
  'scheduleDate': instance.date?.toIso8601String(),
  'recordDate': instance.recordDate,
};
