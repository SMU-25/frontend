import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/common/component/yes_or_no_dialog.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/common/utils/secure_storage_service.dart';
import 'package:team_project_front/common/view/root_tab.dart';
import 'package:team_project_front/main.dart';
import 'package:team_project_front/mypage/component/illness_selctor.dart';
import 'package:team_project_front/mypage/component/profile_birth_input.dart';
import 'package:team_project_front/mypage/component/profile_body_info_input.dart';
import 'package:team_project_front/mypage/component/profile_gender_selector.dart';
import 'package:team_project_front/mypage/component/profile_image_with_add_icon.dart';
import 'package:team_project_front/mypage/component/profile_name_input.dart';
import 'package:team_project_front/mypage/component/seizure_history_selector.dart';
import 'package:team_project_front/mypage/models/profile_info.dart';
import 'package:team_project_front/mypage/utils/image_pick_handler.dart';
import 'package:team_project_front/mypage/utils/validators.dart';
import 'package:team_project_front/settings/component/custom_appbar.dart';

Future<ProfileInfo?> fetchChildDetail({
  required int childId,
  required String accessToken,
}) async {
  final dio = Dio();

  try {
    final resp = await dio.get(
      '$base_URL/children/$childId',
      options: Options(
        headers: {
          'Authorization': accessToken,
        },
      ),
    );

    final data = resp.data['result'];
    final birthDateParts = (data['birthdate'] as String).split('-');

    return ProfileInfo(
      childId: childId,
      name: data['name'],
      birthYear: birthDateParts[0],
      birthMonth: birthDateParts[1],
      birthDay: birthDateParts[2],
      height: (data['height'] as num).toDouble(),
      weight: (data['weight'] as num).toDouble(),
      gender: _mapGenderToKor(data['gender']),
      seizureHistory: _mapSeizureToKor(data['seizure']),
      illnessList: List<String>.from(data['illnessTypes'] ?? [])
          .map((e) => e.replaceAll('_', ' '))
          .toList(),
      image: null,
      profileImage: data['profileImage'],
    );
  } catch (e) {
    print('아이 상세 정보 로드 실패: $e');
    return null;
  }
}

String _mapGenderToKor(String? code) {
  switch (code) {
    case 'MALE':
      return '남자';
    case 'FEMALE':
      return '여자';
    default:
      return '모름';
  }
}

String _mapSeizureToKor(String? code) {
  switch (code) {
    case 'YES':
      return '있음';
    case 'NONE':
      return '없음';
    default:
      return '모름';
  }
}

class EditBabyProfile extends StatefulWidget {
  final ProfileInfo profileInfo;

  const EditBabyProfile({
    required this.profileInfo,
    super.key,
  });

  @override
  State<EditBabyProfile> createState() => _EditBabyProfileState();
}

class _EditBabyProfileState extends State<EditBabyProfile> {
  late final TextEditingController nameController;
  late final TextEditingController heightController;
  late final TextEditingController weightController;

  late String? yearText;
  late String? monthText;
  late String? dayText;
  late String? gender;
  File? image;
  String? seizure;
  Set<String> selectedIllness = {};

  String? accessToken;

  final List<String> illnesses = [
    '해당 없음', '아토피', '천식', '뇌전증',
    '고혈압', '심장 질환', '폐 질환',
    '간 질환', '신장 질환', '면역력 저하',
  ];

  final List<String> seizureOptions = ['있음', '없음', '모름'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    final token = await SecureStorageService.getAccessToken();

    if (token == null) {
      print('accessToken 없음! 로그인 필요');
      return;
    }

    setState(() {
      accessToken = 'Bearer $token';
    });

    final p = widget.profileInfo;

    nameController = TextEditingController(text: p.name);
    heightController = TextEditingController(text: p.height.toString());
    weightController = TextEditingController(text: p.weight.toString());

    yearText = p.birthYear;
    monthText = p.birthMonth;
    dayText = p.birthDay;
    gender = p.gender;
    image = p.image;

    seizure = p.seizureHistory;
    selectedIllness = {...?p.illnessList};

    setState(() {
      isLoading = false;
    });
  }

  bool get isFormValid {
    return _formKey.currentState?.validate() == true &&
        yearText != null &&
        monthText != null &&
        dayText != null &&
        gender != null &&
        seizure != null;
  }

  void onNextPressed() async {
    if(accessToken == null) {
      print('accessToken 없음. 요청 중단.');
      return;
    }

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

    if (image != null) {
      final compressed = await compressImage(image!);
      if (compressed != null) {
        image = compressed;
        print('압축 성공: ${image!.path}, 크기: ${await image!.length()} bytes');
      } else {
        print('압축 실패. 원본 이미지 사용');
      }
    }

    final updatedProfile = ProfileInfo(
      childId: widget.profileInfo.childId,
      name: nameController.text,
      birthYear: yearText!,
      birthMonth: monthText!,
      birthDay: dayText!,
      height: double.tryParse(heightController.text) ?? 0,
      weight: double.tryParse(weightController.text) ?? 0,
      gender: gender!,
      seizureHistory: seizure,
      illnessList: selectedIllness.toList(),
      image: image,
      profileImage: widget.profileInfo.profileImage,
    );

    final dio = Dio();
    final String formattedDate =
        '${updatedProfile.birthYear}-${updatedProfile.birthMonth.padLeft(2, '0')}-${updatedProfile.birthDay.padLeft(2, '0')}';

    final Map<String, dynamic> jsonBody = {
      "name": updatedProfile.name,
      "birthdate": formattedDate,
      "height": updatedProfile.height,
      "weight": updatedProfile.weight,
      "gender": updatedProfile.gender == '남자' ? 'MALE' : 'FEMALE',
      "seizure": _mapKorToSeizureCode(updatedProfile.seizureHistory),
      "illnessTypes": updatedProfile.illnessList?.map((e) => e.replaceAll(' ', '_')).toList(),
    };

    try {
      final response = await dio.patch(
        '$base_URL/children/${updatedProfile.childId}',
        data: jsonBody,
        options: Options(
          headers: {
            'Authorization': accessToken,
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.data['isSuccess'] == true) {
        print('아이 정보 수정 성공');
        if (image != null) {
          final formData = FormData.fromMap({
            "profileImage": await MultipartFile.fromFile(
              image!.path,
              filename: image!.path.split('/').last,
            ),
          });

          final imageResponse = await dio.patch(
            '$base_URL/children/${updatedProfile.childId}/profile-image',
            data: formData,
            options: Options(
              headers: {
                'Authorization': accessToken,
                'Content-Type': 'multipart/form-data',
              },
            ),
          );

          if (imageResponse.data['isSuccess'] == true) {
            print('프로필 이미지 수정 성공');
          } else {
            print('프로필 이미지 수정 실패: ${imageResponse.data['message']}');
          }
        }

        // 이동 및 알림
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => RootTab(initialTabIndex: 4)),
                (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('아이 정보가 수정되었습니다.')),
          );
        }
      } else {
        print('아이 정보 수정 실패: ${response.data['message']}');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('수정 실패: ${response.data['message']}')),
          );
        }
      }
    } catch (e) {
      print('예외 발생: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('수정 중 오류가 발생했습니다.')),
        );
      }
    }
  }

  String _mapKorToSeizureCode(String? kor) {
    switch (kor) {
      case '있음':
        return 'YES';
      case '없음':
        return 'NONE';
      default:
        return 'UNKNOWN';
    }
  }

  void onPressedProfileDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => YesOrNoDialog(
        title: '${nameController.text} 프로필 삭제',
        content:
        '${nameController.text}의 모든 데이터가 삭제되며\n'
            '복구가 불가능합니다.\n'
            '정말 삭제하시겠습니까?',
        onPressedYes: () async {
          final childId = widget.profileInfo.childId;

          final token = accessToken;
          if (token == null) {
            print('accessToken 없음. 삭제 요청 중단.');
            return;
          }

          final dio = Dio();

          try {
            final resp = await dio.delete(
              '$base_URL/children/$childId',
              options: Options(
                headers: {
                  'Authorization': token,
                },
              ),
            );

            if(resp.data['isSuccess'] == true && resp.data['code'] == '204') {
              navigatorKey.currentState?.pop();

              WidgetsBinding.instance.addPostFrameCallback((_) {
                navigatorKey.currentState?.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => RootTab(initialTabIndex: 4)),
                      (route) => false,
                );
              });
            } else {
              print('삭제 실패: ${resp.data}');
            }
          } catch(e) {
            print('아이 삭제 요청 중 오류 발생: $e');
          }
        },
        yesText: '확인',
        noText: '취소',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: CustomAppbar(
          title: '프로필 수정',
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: TextButton(
                onPressed: () {
                  onPressedProfileDelete(context);
                },
                child: Text(
                  '프로필\n삭제',
                  style: TextStyle(
                    color: HIGH_FEVER_COLOR,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
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
                  networkImageUrl: widget.profileInfo.profileImage,
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
              SizedBox(height: 20),
              SeizureHistorySelector(
                selected: seizure,
                options: seizureOptions,
                onSelected: (val) => setState(() => seizure = val),
              ),
              SizedBox(height: 20),
              IllnessSelector(
                illnesses: illnesses,
                selectedIllnesses: selectedIllness,
                onSelectionChanged: (newSet) => setState(() => selectedIllness = newSet),
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