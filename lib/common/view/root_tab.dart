import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/custom_navigation_bar.dart';
import 'package:team_project_front/mypage/view/my_screen.dart';
import 'package:team_project_front/settings/view/settings_screen.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 5, vsync: this);
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
          // HomeScreen()
          Center(child: Container(child: Text('홈'))),
          // HomeCamScreen()
          Center(child: Container(child: Text('홈캠'))),
          // MapScreen()
          Center(child: Container(child: Text('지도'))),
          // CalendarScreen()
          Center(child: Container(child: Text('캘린더'))),
          // MyScreen()
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

  AppBar? _buildAppBar() {
    switch(currentIndex) {
      case 0:
        return null;
      case 1:
        return AppBar(title: Text('홈캠'),);
      case 2:
        return null;
      case 3:
        return AppBar(title: Text('캘린더'));
      case 4:
        return AppBar(
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '마이페이지',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SettingsScreen())
                    );
                  },
                  icon: Icon(
                    Icons.settings,
                    size: 36,
                  ),

              ),
            )
          ],
        );
      default:
        return null;
    }
  }
}
