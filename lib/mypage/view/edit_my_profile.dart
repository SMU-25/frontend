import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/common/const/base_url.dart';
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
  String? social;
  File? image;
  String? networkImageUrl;

  String? customEmailDomain;
  bool isLoading = true;

  // 추후에 accessToken FlutterSecureStorage에서 가져오도록 변경 예정
  final accessToken = 'Bearer ACCESS_TOKEN';

  @override
  void initState() {
    super.initState();
    loadMyInfo();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  Future<void> loadMyInfo() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        '$base_URL/my',
        options: Options(headers: {'Authorization': accessToken}),
      );

      final data = response.data['result'];
      final birthdate = DateTime.parse(data['birthdate']);
      final email = data['email'];
      final emailId = email.split('@')[0];
      final emailDomain = email.split('@')[1];

      final profileImageRaw = data['profileImage'];

      if (profileImageRaw.startsWith('http')) {
        networkImageUrl = profileImageRaw;
      } else {
        networkImageUrl = '$base_URL/$profileImageRaw';
      }

      myProfile = GuardianProfile(
        name: data['name'],
        birthYear: birthdate.year.toString(),
        birthMonth: birthdate.month.toString().padLeft(2, '0'),
        birthDay: birthdate.day.toString().padLeft(2, '0'),
        gender: data['gender'] == 'FEMALE' ? '여자' : '남자',
        image: null,
        email: email,
        password: '',
        socialType: data['socialType'],
      );

      nameController = TextEditingController(text: myProfile.name);
      emailIdController = TextEditingController(text: emailId);

      if (emailDomain == 'gmail.com' || emailDomain == 'naver.com') {
        emailDomainController = TextEditingController(text: emailDomain);
        customEmailDomain = null;
      } else {
        emailDomainController = TextEditingController(text: '직접입력');
        customEmailDomain = emailDomain;
      }

      yearText = myProfile.birthYear;
      monthText = myProfile.birthMonth;
      dayText = myProfile.birthDay;
      gender = myProfile.gender;
      image = myProfile.image;

      setState(() {
        isLoading = false;
      });
    } catch(e) {
      print('본인 정보 조회 실패: $e');
    }
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
        (emailDomainController.text != '직접입력' || (customEmailDomain?.isNotEmpty ?? false));
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

  void onNextPressed() async {
    final dio = Dio();
    final domain = emailDomainController.text == '직접입력'
        ? customEmailDomain ?? ''
        : emailDomainController.text;

    final updatedProfile = GuardianProfile(
      name: nameController.text,
      birthYear: yearText!,
      birthMonth: monthText!,
      birthDay: dayText!,
      gender: gender!,
      image: image,
      email: '${emailIdController.text}@$domain',
      password: myProfile.socialType == 'LOCAL'
          ? (passwordController.text.isEmpty
          ? myProfile.password
          : passwordController.text)
          : '',
      socialType: myProfile.socialType,
    );

    final requestBody = {
      "name": updatedProfile.name,
      "birthdate": "${updatedProfile.birthYear}-${updatedProfile.birthMonth}-${updatedProfile.birthDay}",
      "gender": updatedProfile.gender == "여자" ? "FEMALE" : "MALE",
      if (updatedProfile.socialType == "LOCAL" &&
          updatedProfile.password.isNotEmpty)
        "newPassword": updatedProfile.password,
    };

    Future<File?> compressImage(File file) async {
      final filePath = file.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
      final splitted = filePath.substring(0, lastIndex);
      final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

      final compressedXFile = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        quality: 60,
      );

      if (compressedXFile == null) return null;

      return File(compressedXFile.path);
    }


    try {
      if (image != null) {
        final compressed = await compressImage(image!);
        if (compressed != null) {
          final fileName = compressed.path.split('/').last;

          final formData = FormData.fromMap({
            "profileImage": await MultipartFile.fromFile(
              compressed.path,
              filename: fileName,
            ),
          });

          try {
            final imageResponse = await dio.patch(
              "$base_URL/my/profile-image",
              data: formData,
              options: Options(
                headers: {
                  "Authorization": accessToken,
                  "Content-Type": "multipart/form-data",
                },
              ),
            );

            if (imageResponse.data["isSuccess"] != true) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("이미지 수정 실패: ${imageResponse.data['message']}")),
                );
              }
              return;
            }
          } catch (e) {
            print("이미지 업로드 실패: $e");
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("이미지 업로드 중 오류 발생")),
              );
            }
          }
        } else {
          print("이미지 압축 실패");
        }
      }

      final response = await dio.patch(
        "$base_URL/my",
        data: requestBody,
        options: Options(
          headers: {"Authorization": accessToken},
        ),
      );

      if (response.data["isSuccess"] == true) {
        if (context.mounted) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("내 정보가 성공적으로 수정되었어요!")),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("수정 실패: ${response.data['message']}")),
          );
        }
      }
    } catch(e) {
      print("PATCH 실패: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("알 수 없는 오류가 발생했어요.")),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                  networkImageUrl: networkImageUrl,
                  profileIconSize: 90,
                  addImageIconSize: 18,
                  bottom: 0,
                  right: -5,
                  radius: 50,
                  onPressedChangePic: () => handleImagePick(
                    context: context,
                    onImageSelected: (selectedImage) {
                      setState(() {
                        image = File(selectedImage.path);
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              EmailInput(
                emailIdController: emailIdController,
                emailDomainController: emailDomainController,
                customEmailDomain: customEmailDomain,
                onCustomEmailDomainChanged: (val) {
                  setState(() {
                    customEmailDomain = val;
                  });
                },
                isReadOnly: true,
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
              if(myProfile.socialType == 'LOCAL') ...[
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
              ],
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