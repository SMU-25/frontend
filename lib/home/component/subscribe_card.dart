import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class SubscribeCard extends StatelessWidget {
  const SubscribeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 155,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        border: Border.all(color: INPUT_BORDER_COLOR),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            // 구독 사이트 라우팅 연결
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 20),
              backgroundColor: Color(0xFFFBBC05),
            ),
            child: Text(
              '프리미엄 구독',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          SizedBox(height: 8),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '초보 부모도 손쉽게\n진료 준비 끝!',
                  style: TextStyle(fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '맘편해 리포트가 \n다~ 챙겨줘요 😊',
                  style: TextStyle(fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
