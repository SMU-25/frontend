// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  name: json['name'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
  birthDate: User._birthDateFromJson(json['birthdate'] as String),
  socialType: json['socialType'] as String,
  gender: $enumDecode(_$GenderEnumMap, json['gender']),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'password': instance.password,
  'birthdate': User._birthDateToJson(instance.birthDate),
  'socialType': instance.socialType,
  'gender': _$GenderEnumMap[instance.gender]!,
};

const _$GenderEnumMap = {Gender.male: 'male', Gender.female: 'female'};
