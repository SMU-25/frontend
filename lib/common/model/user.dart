enum Gender { male, female }

class User {
  final String name;
  final String email;
  final String password;
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
}
