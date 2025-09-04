import 'package:flutter/material.dart';
import 'package:team_project_front/calendar/view/calendar_screen.dart';
import 'package:team_project_front/common/component/custom_appbar_root_tab.dart';
import 'package:team_project_front/common/component/custom_navigation_bar.dart';
import 'package:team_project_front/home/view/home.dart';
import 'package:team_project_front/homecam/view/home_cam_list.dart';
import 'package:team_project_front/map/view/map_screen.dart';
import 'package:team_project_front/mypage/view/my_screen.dart';
import 'package:team_project_front/settings/view/settings_screen.dart';

class RootTab extends StatefulWidget {
  final int initialTabIndex;

  const RootTab({this.initialTabIndex = 0, super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialTabIndex;
    controller = TabController(
      length: 5,
      vsync: this,
      initialIndex: currentIndex,
    );
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      currentIndex = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          HomeScreen(),
          HomeCamListScreen(),
          MapScreen(),
          CalendarScreen(),
          MyScreen(),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onTap,
      ),
    );
  }

  void _onTap(int index) {
    setState(() {
      currentIndex = index;
      controller.animateTo(index);
    });
  }

  PreferredSizeWidget? _buildAppBar() {
    switch (currentIndex) {
      case 0:
        return null;
      case 2:
        return null;
      case 1:
      case 3:
      case 4:
        return CustomAppbarRootTab(
          title: getAppBarTitle(),
          height: getAppBarHeight(),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
          },
        );
      default:
        return null;
    }
  }

  String getAppBarTitle() {
    switch (currentIndex) {
      case 1:
        return '홈캠';
      case 3:
        return '캘린더';
      case 4:
        return '마이페이지';
      default:
        return '';
    }
  }

  double getAppBarHeight() {
    switch (currentIndex) {
      case 1: // 홈캠
        return 70.0;
      case 3: // 캘린더
        return 70.0;
      case 4: // 마이
        return 70.0;
      default:
        return 70.0; // 기본값
    }
  }
}
