// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'baby.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Baby _$BabyFromJson(Map<String, dynamic> json) => Baby(
  childId: (json['childId'] as num?)?.toInt(),
  name: json['name'] as String,
  birthDate: _fromJsonBirthDate(json['birthdate'] as String?),
  height: (json['height'] as num?)?.toDouble(),
  weight: (json['weight'] as num?)?.toDouble(),
  gender: $enumDecodeNullable(_$BabyGenderEnumMap, json['gender']),
  seizure: json['seizure'] as String?,
  profileImage: json['profileImage'] as String?,
  illnessTypes: (json['illnessTypes'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$BabyToJson(Baby instance) => <String, dynamic>{
  'childId': instance.childId,
  'name': instance.name,
  'birthdate': _toJsonBirthDate(instance.birthDate),
  'height': instance.height,
  'weight': instance.weight,
  'gender': _$BabyGenderEnumMap[instance.gender],
  'seizure': instance.seizure,
  'profileImage': instance.profileImage,
  'illnessTypes': instance.illnessTypes,
};

const _$BabyGenderEnumMap = {
  BabyGender.male: 'MALE',
  BabyGender.female: 'FEMALE',
};
