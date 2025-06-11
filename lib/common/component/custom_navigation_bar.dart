import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        selectedItemColor: MAIN_COLOR,
        unselectedItemColor: ICON_GREY_COLOR,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        onTap: onTap,
        currentIndex: currentIndex,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w700
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w700
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            label: '홈캠',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: '지도',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '캘린더',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이',
          ),
        ]
    );
  }
}
