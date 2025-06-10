import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/common/view/root_tab.dart';

void main() {
  runApp(_App());
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSans',
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: RootTab(),
    );
  }
}

