import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/custom_input.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/common/utils/image_picker_utils.dart';
import 'package:team_project_front/mypage/component/profile_image_with_add_icon.dart';
import 'package:team_project_front/mypage/models/profile_info.dart';
import 'package:team_project_front/mypage/utils/date_picker_utils.dart';
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

  String? validateHeight(String? value) {
    if (value == null || value.isEmpty) return '값을 입력해주세요';
    final parsed = double.tryParse(value);
    if (parsed == null) return '숫자만 입력해주세요';
    if (parsed < 0 || parsed > 200) return '0~200 사이로 입력해주세요';
    if (!RegExp(r'^\d{1,3}(\.\d)?$').hasMatch(value)) return '소수 첫째자리까지 입력해주세요';
    return null;
  }

  String? validateWeight(String? value) {
    if (value == null || value.isEmpty) return '값을 입력해주세요';
    final parsed = double.tryParse(value);
    if (parsed == null) return '숫자만 입력해주세요';
    if (parsed < 0 || parsed > 100) return '0~100 사이로 입력해주세요';
    if (!RegExp(r'^\d{1,3}(\.\d)?$').hasMatch(value)) return '소수 첫째자리까지 입력해주세요';
    return null;
  }

  Future<void> onPressedChangePic() async {
    final selectedImage = await pickImageFromGallery();

    if(selectedImage != null) {
      setState(() {
        image = selectedImage;
      });
    } else {
      print('사진이 선택되지 않았습니다.');
    }
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
                    onPressedChangePic: onPressedChangePic,
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
              Text(
                '이름 / 닉네임',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              CustomTextFormField(
                controller: nameController,
                hintText: '이름 또는 애칭 입력(2-8자)',
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return '이름을 입력해주세요';
                  }
                  if (val.length < 2 || val.length > 8) {
                    return '2~8자 이내로 입력해주세요';
                  }
                  if (!RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(val)) {
                    return '한글 또는 영문만 입력 가능합니다';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                '생년월일',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => showYearPicker(
                        context: context,
                        initialYear: yearText,
                        onSelected: (val) => setState(() => yearText = val),
                      ),
                      child: AbsorbPointer(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: '0000',
                            hintStyle: TextStyle(
                              color: INPUT_BORDER_COLOR,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: ICON_GREY_COLOR,
                                width: 1.5,
                              )
                            ),
                          ),
                          controller: TextEditingController(text: yearText),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  Text('년'),
                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => showMonthPicker(
                        context: context,
                        initialMonth: monthText,
                        onSelected: (val) => setState(() => monthText = val),
                      ),
                      child: AbsorbPointer(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: '00',
                            hintStyle: TextStyle(
                              color: INPUT_BORDER_COLOR,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: ICON_GREY_COLOR,
                                width: 1.5,
                              )
                            ),
                          ),
                          controller: TextEditingController(text: monthText),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  Text('월'),
                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => showDayPicker(
                        context: context,
                        initialDay: dayText,
                        onSelected: (val) => setState(() => dayText = val),
                      ),
                      child: AbsorbPointer(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: '00',
                            hintStyle: TextStyle(
                              color: INPUT_BORDER_COLOR,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: ICON_GREY_COLOR,
                                  width: 1.5,
                              )
                            ),
                          ),
                          controller: TextEditingController(text: dayText),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  Text('일'),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('키', style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: heightController,
                                validator: validateHeight,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: '0.0',
                                  hintStyle: TextStyle(color: INPUT_BORDER_COLOR),
                                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: ICON_GREY_COLOR, width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: MAIN_COLOR, width: 2.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 6),
                            Text('cm'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('몸무게', style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        )),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: weightController,
                                validator: validateWeight,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: '0.0',
                                  hintStyle: TextStyle(color: INPUT_BORDER_COLOR),
                                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: ICON_GREY_COLOR, width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: MAIN_COLOR, width: 2.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 6),
                            Text('kg'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                '성별',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  for (int i = 0; i < genders.length; i++) ...[
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () => setState(() {
                            gender = genders[i];
                          }),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gender == genders[i]
                                ? MAIN_COLOR.withValues(alpha: 0.13)
                                : Theme.of(context).scaffoldBackgroundColor,
                            foregroundColor: gender == genders[i]
                                ? MAIN_COLOR
                                : Colors.black54,
                            side: BorderSide(
                              color: gender == genders[i]
                                  ? MAIN_COLOR
                                  : ICON_GREY_COLOR,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ).copyWith(
                            overlayColor: WidgetStateProperty.all(Colors.transparent),
                            splashFactory: NoSplash.splashFactory,
                            animationDuration: Duration.zero,
                            shadowColor: WidgetStateProperty.all(Colors.transparent),
                          ),
                          child: Text(
                            genders[i],
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    if (i != 1) SizedBox(width: 16), // 버튼 사이 간격
                  ]
                ],
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