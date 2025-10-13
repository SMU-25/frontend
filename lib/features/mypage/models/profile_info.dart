import 'dart:io';

class ProfileInfo {
  final int? childId;
  final String name;
  final String birthYear;
  final String birthMonth;
  final String birthDay;
  final double height;
  final double weight;
  final String gender;
  final String? seizureHistory;
  final List<String>? illnessList;
  final File? image;
  final String? profileImage;

  ProfileInfo({
    this.childId,
    required this.name,
    required this.birthYear,
    required this.birthMonth,
    required this.birthDay,
    required this.height,
    required this.weight,
    required this.gender,
    this.seizureHistory,
    this.illnessList,
    this.image,
    this.profileImage,
  });

  ProfileInfo copyWith({
    int? childId,
    String? name,
    String? birthYear,
    String? birthMonth,
    String? birthDay,
    double? height,
    double? weight,
    String? gender,
    String? seizureHistory,
    List<String>? illnessList,
    File? image,
    String? profileImage,
  }) {
    return ProfileInfo(
      childId: childId ?? this.childId,
      name: name ?? this.name,
      birthYear: birthYear ?? this.birthYear,
      birthMonth: birthMonth ?? this.birthMonth,
      birthDay: birthDay ?? this.birthDay,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      seizureHistory: seizureHistory ?? this.seizureHistory,
      illnessList: illnessList ?? this.illnessList,
      image: image ?? this.image,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}