import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/custom_navigation_bar.dart';

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
          Center(child: Container(child: Text('마이'))),
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
}
