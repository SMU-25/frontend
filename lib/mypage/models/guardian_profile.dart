import 'dart:io';

class GuardianProfile {
  final String name;
  final String birthYear;
  final String birthMonth;
  final String birthDay;
  final String gender;
  final File? image;
  final String email;
  final String password;

  GuardianProfile({
    required this.name,
    required this.birthYear,
    required this.birthMonth,
    required this.birthDay,
    required this.gender,
    this.image,
    required this.email,
    required this.password,
  });
}