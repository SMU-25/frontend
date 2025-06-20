import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/common/const/colors.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _InitScreenState();
  }
}

class _InitScreenState extends State<InitScreen> {
  double logoSize = 250;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 이미지 파일 누끼따야함
            Image.asset(
              'asset/img/logo/mom_fill_logo.png',
              height: logoSize,
              width: logoSize,
            ),
            Text(
              '맘편해',
              style: TextStyle(
                color: MAIN_COLOR,
                fontSize: 80,
                fontFamily: 'BMJUA',
              ),
            ),
            Text(
              '우리 아이 체온 관리 앱',
              style: TextStyle(
                color: MAIN_COLOR,
                fontSize: 25,
                fontFamily: 'BMJUA',
              ),
            ),
            SizedBox(height: 200),
            NavigationButton(
              text: '시작',
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
