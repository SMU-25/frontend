// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportInfo _$ReportInfoFromJson(Map<String, dynamic> json) => ReportInfo(
  reportId: (json['reportId'] as num).toInt(),
  childId: (json['childId'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  symptoms: (json['symptoms'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  etcSymptom: json['etcSymptom'] as String,
  outingRecord: json['outingRecord'] as String,
  illnesses: (json['illnesses'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  special: json['special'] as String,
  day1: ReportStats.fromJson(json['day1'] as Map<String, dynamic>),
  day3: ReportStats.fromJson(json['day3'] as Map<String, dynamic>),
  day7: ReportStats.fromJson(json['day7'] as Map<String, dynamic>),
);
