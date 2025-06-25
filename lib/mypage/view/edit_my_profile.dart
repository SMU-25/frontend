import 'dart:io';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/mypage/component/email_input.dart';
import 'package:team_project_front/mypage/component/password_input.dart';
import 'package:team_project_front/mypage/component/profile_birth_input.dart';
import 'package:team_project_front/mypage/component/profile_gender_selector.dart';
import 'package:team_project_front/mypage/component/profile_image_with_add_icon.dart';
import 'package:team_project_front/mypage/component/profile_name_input.dart';
import 'package:team_project_front/mypage/models/guardian_profile.dart';
import 'package:team_project_front/mypage/utils/image_pick_handler.dart';
import 'package:team_project_front/settings/component/custom_appbar.dart';

class EditMyProfile extends StatefulWidget {
  const EditMyProfile({super.key});

  @override
  State<EditMyProfile> createState() => _EditMyProfileState();
}

class _EditMyProfileState extends State<EditMyProfile> {
  late GuardianProfile myProfile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailIdController;
  late TextEditingController emailDomainController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  String? yearText;
  String? monthText;
  String? dayText;
  String? gender;
  File? image;

  @override
  void initState() {
    super.initState();
    myProfile = GuardianProfile(
      name: '홍길동',
      birthYear: '1995',
      birthMonth: '08',
      birthDay: '22',
      gender: '남자',
      image: null,
      email: 'test@example.com',
      password: '',
    );

    nameController = TextEditingController(text: myProfile.name);
    emailIdController = TextEditingController(text: myProfile.email.split('@').first);
    emailDomainController = TextEditingController(text: myProfile.email.split('@').last);
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    yearText = myProfile.birthYear;
    monthText = myProfile.birthMonth;
    dayText = myProfile.birthDay;
    gender = myProfile.gender;
    image = myProfile.image;
  }

  bool get isFormValid {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    final hasLowercase = password.contains(RegExp(r'[a-zA-Z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[!@#&*~%^()_+=\-]'));
    final isLengthValid = password.length >= 8 && password.length <= 16;
    final isPasswordMatch = password == confirmPassword;

    final isEmailValid = emailIdController.text.isNotEmpty &&
      emailDomainController.text.isNotEmpty;
    final isBirthdaySelected =
      yearText != null && monthText != null && dayText != null;
    final isPasswordValid = password.isEmpty || (
      hasLowercase &&
      hasNumber &&
      hasSpecial &&
      isLengthValid &&
      isPasswordMatch
    );

    return _formKey.currentState?.validate() == true &&
      nameController.text.isNotEmpty &&
      gender != null &&
      isBirthdaySelected &&
      isEmailValid &&
      isPasswordValid;
  }

  void onNextPressed() {
    final updatedProfile = GuardianProfile(
      name: nameController.text,
      birthYear: yearText!,
      birthMonth: monthText!,
      birthDay: dayText!,
      gender: gender!,
      image: image,
      email: '${emailIdController.text}@${emailDomainController.text}',
      password: passwordController.text.isEmpty
        ? myProfile.password
        : passwordController.text,
    );

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('내 정보가 성공적으로 수정되었어요!')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: CustomAppbar(
          title: '내 정보 수정',
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          onChanged: () => setState(() {}),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: ProfileImageWithAddIcon(
                  image: image,
                  profileIconSize: 90,
                  addImageIconSize: 18,
                  bottom: 0,
                  right: -5,
                  radius: 50,
                  onPressedChangePic: () => handleImagePick(
                    context: context,
                    onImageSelected: (selectedImage) {
                      setState(() {
                        image = selectedImage;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              EmailInput(
                emailIdController: emailIdController,
                emailDomainController: emailDomainController,
              ),
              SizedBox(height: 10),
              ProfileNameInput(controller: nameController),
              SizedBox(height: 20),
              ProfileBirthInput(
                yearText: yearText,
                monthText: monthText,
                dayText: dayText,
                onYearSelected: (val) => setState(() => yearText = val),
                onMonthSelected: (val) => setState(() => monthText = val),
                onDaySelected: (val) => setState(() => dayText = val),
              ),
              SizedBox(height: 20),
              ProfileGenderSelector(
                selectedGender: gender,
                onGenderSelected: (val) => setState(() => gender = val),
              ),
              SizedBox(height: 20),
              Text(
                '새 비밀번호',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              PasswordInput(
                passwordController: passwordController,
                confirmController: confirmPasswordController,
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: NavigationButton(
          text: '수정 완료',
          onPressed: isFormValid ? onNextPressed : null,
        ),
      )
    );
  }
}