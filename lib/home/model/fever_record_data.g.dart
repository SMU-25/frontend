// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fever_record_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeverRecord _$FeverRecordFromJson(Map<String, dynamic> json) => FeverRecord(
  fever: (json['fever'] as num?)?.toDouble(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$FeverRecordToJson(FeverRecord instance) =>
    <String, dynamic>{
      'fever': instance.fever,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
