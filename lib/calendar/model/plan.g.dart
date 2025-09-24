// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Plan _$PlanFromJson(Map<String, dynamic> json) => Plan(
  calendarId: (json['calendarId'] as num).toInt(),
  recordDate: json['recordDate'] as String,
  date: DateTime.parse(json['date'] as String),
  title: json['title'] as String,
  content: json['content'] as String,
);

Map<String, dynamic> _$PlanToJson(Plan instance) => <String, dynamic>{
  'calendarId': instance.calendarId,
  'title': instance.title,
  'content': instance.content,
  'date': instance.date.toIso8601String(),
  'recordDate': instance.recordDate,
};
