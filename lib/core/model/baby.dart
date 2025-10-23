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
  @JsonKey(
    name: 'birthdate',
    fromJson: _fromJsonBirthDate,
    toJson: _toJsonBirthDate,
  )
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

  @override
  String toString() {
    return 'Baby(childId: $childId, name: $name, birthDate: $birthDate, '
        'height: $height, weight: $weight, gender: $gender, seizure: $seizure, '
        'profileImage: $profileImage, illnessTypes: $illnessTypes)';
  }
}

DateTime? _fromJsonBirthDate(String? date) {
  if (date == null) return null;
  try {
    return DateTime.parse(date);
  } catch (_) {
    return null;
  }
}

String? _toJsonBirthDate(DateTime? date) =>
    date?.toIso8601String().split('T').first;

extension BabyCopyWith on Baby {
  Baby copyWith({
    int? childId,
    String? name,
    DateTime? birthDate,
    double? height,
    double? weight,
    BabyGender? gender,
    String? seizure,
    String? profileImage,
    List<String>? illnessTypes,
  }) {
    return Baby(
      childId: childId ?? this.childId,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      seizure: seizure ?? this.seizure,
      profileImage: profileImage ?? this.profileImage,
      illnessTypes: illnessTypes ?? this.illnessTypes,
    );
  }
}
