import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonEnum(alwaysCreate: true)
enum Gender {
  @JsonValue('MALE')
  male,
  @JsonValue('FEMALE')
  female,
}

@JsonSerializable()
class User {
  final String name;
  final String email;
  final String password;
  @JsonKey(
    name: 'birthdate',
    toJson: _birthDateToJson,
    fromJson: _birthDateFromJson,
  )
  final DateTime birthDate;

  final String socialType;
  final Gender gender;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.birthDate,
    required this.socialType,
    required this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  static String _birthDateToJson(DateTime date) =>
      date.toIso8601String().split('T').first;
  static DateTime _birthDateFromJson(String date) => DateTime.parse(date);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
