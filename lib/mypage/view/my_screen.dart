import 'dart:io';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/mypage/component/profile_image_with_add_icon.dart';
import 'package:team_project_front/mypage/view/add_profile_screen.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  File? image;
  List<String> members = ['김준형', '최강민'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24),
        MyProfile(
          image: image,
          onPressedChangePic: () {},
          onPressedChangeProfile: () {},
        ),
        SizedBox(height: 36),
        FamilyProfile(
            members: members,
            onPressedAdd: onPressedAdd,
        )
      ],
    );
  }
  
  void onPressedAdd() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddProfileScreen())
    );
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
            onPressedChangePic: onPressedChangePic
        ),
        SizedBox(height: 12),
        Text(
          '보호자',
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
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }
}

class FamilyProfile extends StatelessWidget {
  List<String> members;
  final GestureTapCallback? onPressedAdd;

  FamilyProfile({
    required this.members,
    required this.onPressedAdd,
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
              ...members.map((name) =>
                  Padding(
                    padding: EdgeInsets.only(right: 24),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          child: Icon(Icons.account_circle, size: 60, color: ICON_GREY_COLOR),
                        ),
                        SizedBox(height: 8,),
                        Text(name),
                      ],
                    ),
                  ),
              ),
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
                  SizedBox(height: 8,),
                  Text('추가하기'),
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 36),
        Container(
          height: 1.0,
          width: MediaQuery.of(context).size.width / 1.2,
          color: ICON_GREY_COLOR,
        )
      ],
    );
  }
}