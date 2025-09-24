import 'package:json_annotation/json_annotation.dart';

part 'baby.g.dart';

@JsonEnum(alwaysCreate: true)
enum BabyGender {
  @JsonValue('MALE')
  male,
  @JsonValue('FEMALE')
  female,
}

@JsonSerializable()
class Baby {
  final int? childId;
  final String name;
  final DateTime? birthDate;
  final double? height;
  final double? weight;
  final BabyGender? gender;
  final String? seizure;
  final String? profileImage;
  final List<String>? illnessTypes;

  Baby({
    this.childId,
    required this.name,
    this.birthDate,
    this.height,
    this.weight,
    this.gender,
    this.seizure,
    this.profileImage,
    this.illnessTypes,
  });

  factory Baby.forList({
    required int childId,
    required String name,
    required String profileImage,
  }) {
    return Baby(childId: childId, name: name, profileImage: profileImage);
  }

  factory Baby.fromJson(Map<String, dynamic> json) => _$BabyFromJson(json);
  Map<String, dynamic> toJson() => _$BabyToJson(this);
}
