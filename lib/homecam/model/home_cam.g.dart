// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_cam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeCam _$HomeCamFromJson(Map<String, dynamic> json) => HomeCam(
  name: json['name'] as String,
  place: json['place'] as String,
  childId: (json['childId'] as num).toInt(),
  childName: json['childName'] as String,
  serialNum: json['serialNum'] as String,
  videoUrl: json['videoUrl'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  homecamId: (json['homecamId'] as num).toInt(),
);

Map<String, dynamic> _$HomeCamToJson(HomeCam instance) => <String, dynamic>{
  'name': instance.name,
  'place': instance.place,
  'childId': instance.childId,
  'childName': instance.childName,
  'serialNum': instance.serialNum,
  'videoUrl': instance.videoUrl,
  'createdAt': instance.createdAt.toIso8601String(),
  'homecamId': instance.homecamId,
};
