import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/mypage/component/profile_birth_input.dart';
import 'package:team_project_front/mypage/component/profile_body_info_input.dart';
import 'package:team_project_front/mypage/component/profile_gender_selector.dart';
import 'package:team_project_front/mypage/component/profile_image_with_add_icon.dart';
import 'package:team_project_front/mypage/component/profile_name_input.dart';
import 'package:team_project_front/mypage/models/profile_info.dart';
import 'package:team_project_front/mypage/utils/image_pick_handler.dart';
import 'package:team_project_front/mypage/utils/validators.dart';
import 'package:team_project_front/mypage/view/add_profile_symptoms_screen.dart';
import 'package:team_project_front/settings/component/custom_appbar.dart';

class AddProfileScreen extends StatefulWidget {
  const AddProfileScreen({super.key});

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? yearText;
  String? monthText;
  String? dayText;
  double height = 10.0;
  double weight = 10.0;
  String? gender;
  File? image;

  final List<String> genders = ['여자', '남자'];

  bool get isFormValid =>
    _formKey.currentState?.validate() == true &&
    yearText != null &&
    monthText != null &&
    dayText != null &&
    gender != null;

  void onNextPressed() {
    if(!isFormValid) return;

    final profileInfo = ProfileInfo(
      name: nameController.text.trim(),
      birthYear: yearText!,
      birthMonth: monthText!,
      birthDay: dayText!,
      height: double.parse(heightController.text),
      weight: double.parse(weightController.text),
      gender: gender!,
      image: image,
    );
    
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddProfileSymptomsScreen(
        profileInfo: profileInfo,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: CustomAppbar(
          title: '프로필 등록',
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
                      }
                    ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                '우리 아이 정보를 알려주세요',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 20),
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
              ProfileBodyInfoInput(
                heightController: heightController,
                weightController: weightController,
                validateHeight: validateHeight,
                validateWeight: validateWeight,
              ),
              SizedBox(height: 20),
              ProfileGenderSelector(
                selectedGender: gender,
                onGenderSelected: (val) => setState(() => gender = val),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: NavigationButton(
          text: '다음',
          onPressed: isFormValid ? onNextPressed : null,
        ),
      ),
    );
  }
}