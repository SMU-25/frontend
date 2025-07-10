enum Gender { male, female }

class Baby {
  final String name;
  final DateTime birthDate;
  final double height;
  final double weight;
  final Gender gender;
  final String seizure;
  final String profileImage;
  final List<String> illnessTypes;

  Baby({
    required this.name,
    required this.birthDate,
    required this.height,
    required this.weight,
    required this.gender,
    required this.seizure,
    required this.profileImage,
    required this.illnessTypes,
  });
}
