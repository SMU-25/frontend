import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/mypage/component/profile_image_with_add_icon.dart';
import 'package:team_project_front/mypage/models/profile_info.dart';
import 'package:team_project_front/mypage/utils/image_pick_handler.dart';
import 'package:team_project_front/mypage/view/add_profile_screen.dart';
import 'package:team_project_front/mypage/view/edit_baby_profile.dart';
import 'package:team_project_front/mypage/view/edit_my_profile.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  File? image;
  final ImagePicker picker = ImagePicker();

  // 추후에 accessToken FlutterSecureStorage에서 가져오도록 변경 예정
  final String accessToken = 'Bearer ACCESS_TOKEN';

  List<ProfileInfo> members = [];

  @override
  void initState() {
    super.initState();
    loadChildren();
  }

  void loadChildren() async {
    final data = await fetchChildren(accessToken);
    setState(() {
      members = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24),
        MyProfile(
          image: image,
          onPressedChangePic: () => handleImagePick(
            context: context,
            onImageSelected: (selectedImage) {
              setState(() {
                image = selectedImage;
              });
            },
          ),
          onPressedChangeProfile: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => EditMyProfile())
            );
          },
        ),
        SizedBox(height: 36),
        FamilyProfile(
          members: members,
          onPressedAdd: onPressedAdd,
          onPressedEditBabyProfile: onPressedEditBabyProfile,
        )
      ],
    );
  }

  void onPressedAdd() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddProfileScreen()),
    );
  }

  void onPressedEditBabyProfile(ProfileInfo profile) async {
    if(profile.childId == null) return;

    // 로딩 표시 추가 예정

    final detail = await fetchChildDetail(
      childId: profile.childId!,
      accessToken: accessToken,
    );

    if(detail != null && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => EditBabyProfile(profileInfo: detail),
        ),
      );
    }
  }
}

class MyProfile extends StatelessWidget {
  File? image;
  final GestureTapCallback? onPressedChangePic;
  final VoidCallback? onPressedChangeProfile;

  MyProfile({
    required this.image,
    required this.onPressedChangePic,
    required this.onPressedChangeProfile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileImageWithAddIcon(
          image: image,
          profileIconSize: 140,
          addImageIconSize: 24,
          bottom: 0,
          right: 4,
          radius: 70,
          onPressedChangePic: onPressedChangePic,
        ),
        SizedBox(height: 12),
        Text(
          '홍길동',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'jh010303',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: onPressedChangeProfile,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: MAIN_COLOR,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
          child: Text(
            '내 정보 수정',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class FamilyProfile extends StatelessWidget {
  List<ProfileInfo> members;
  final GestureTapCallback? onPressedAdd;
  final void Function(ProfileInfo)? onPressedEditBabyProfile;

  FamilyProfile({
    required this.members,
    required this.onPressedAdd,
    this.onPressedEditBabyProfile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1.0,
          width: MediaQuery.of(context).size.width / 1.2,
          color: ICON_GREY_COLOR,
        ),
        SizedBox(height: 28),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 48),
            child: Text(
              '가족 구성원 관리',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ),
        ),
        SizedBox(height: 28),
        Padding(
          padding: EdgeInsets.only(left: 48),
          child: Row(
            children: [
              ...members.map((profile) => Padding(
                padding: EdgeInsets.only(right: 24),
                child: GestureDetector(
                  onTap: () => onPressedEditBabyProfile?.call(profile),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.transparent,
                        backgroundImage: profile.profileImage != null && profile.profileImage != "string"
                            ? NetworkImage(profile.profileImage!)
                            : null,
                        child: (profile.profileImage == null || profile.profileImage == "string")
                            ? Icon(Icons.account_circle, size: 60, color: ICON_GREY_COLOR)
                            : null,
                      ),
                      SizedBox(height: 8),
                      Text(profile.name),
                    ],
                  ),
                ),
              )),
              Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    child: GestureDetector(
                      onTap: onPressedAdd,
                      child: Icon(Icons.add_circle, size: 60, color: ICON_GREY_COLOR),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('추가하기'),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 36),
        Container(
          height: 1.0,
          width: MediaQuery.of(context).size.width / 1.2,
          color: ICON_GREY_COLOR,
        ),
      ],
    );
  }
}

Future<List<ProfileInfo>> fetchChildren(String accessToken) async {
  final dio = Dio();

  try {
    final resp = await dio.get(
      'https://momfy.kr/api/children',
      options: Options(
        headers: {
          'Authorization': accessToken,
        },
      ),
    );

    final List result = resp.data['result'];
    
    return result.map((e) =>
      ProfileInfo(
        childId: e['childId'],
        name: e['name'],
        birthYear: '',
        birthMonth: '',
        birthDay: '',
        height: 0.0,
        weight: 0.0,
        gender: '',
        seizureHistory: null,
        illnessList: [],
        image: null,
        profileImage: e['profileImage'],
      )).toList();
  } catch (e) {
    print('아이 목록 api 호출 실패: $e');
    return [];
  }
}
