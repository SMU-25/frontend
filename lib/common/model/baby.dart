enum Gender { male, female }

class Baby {
  final int? childId;
  final String name;
  final DateTime? birthDate;
  final double? height;
  final double? weight;
  final Gender? gender;
  final String? seizure;
  final String profileImage;
  final List<String>? illnessTypes;

  Baby({
    this.childId,
    required this.name,
    this.birthDate,
    this.height,
    this.weight,
    this.gender,
    this.seizure,
    required this.profileImage,
    this.illnessTypes,
  });

  factory Baby.forList({
    required int childId,
    required String name,
    required String profileImage,
  }) {
    return Baby(childId: childId, name: name, profileImage: profileImage);
  }

  @override
  String toString() {
    return 'Baby(childId: $childId, name: $name, birthDate: $birthDate, height: $height, weight: $weight, gender: $gender, seizure: $seizure, profileImage: $profileImage, illnessTypes: $illnessTypes)';
  }
}
