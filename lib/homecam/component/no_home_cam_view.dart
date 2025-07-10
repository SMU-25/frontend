import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/homecam/view/create_home_cam.dart';

class NoHomeCamView extends StatelessWidget {
  const NoHomeCamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _CardButton(
            text: '홈캠 등록이 필요합니다!',
            buttonText: '기기 등록하기',
            buttonColor: Color(0xFF64CCC5),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateHomeCamScreen()),
              );
            },
          ),
          SizedBox(height: 24),
          _CardButton(
            text: '홈캠이 없으신가요?',
            buttonText: '구독하러 가기',
            buttonColor: Colors.amber,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _CardButton extends StatelessWidget {
  final String text;
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onPressed;

  const _CardButton({
    required this.text,
    required this.buttonText,
    required this.buttonColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: INPUT_BORDER_COLOR, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 19,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
