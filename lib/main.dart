import 'package:flutter/material.dart';
import 'package:team_project_front/common/view/root_tab.dart';
import 'package:team_project_front/init/view/init.dart';
import 'package:team_project_front/login/view/login.dart';
import 'package:team_project_front/report/view/create_report.dart';
import 'package:team_project_front/signup/view/signup_agreement.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

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

      // home: RootTab(),
      // Named Routes 적용 화면 개발시 initialRoute를 바꿔주면서 진행하면 편리합니다.
      // ex) login 화면 개발 중이라면 initialRoute: '/login',
      initialRoute: '/home',
      routes: {
        '/': (context) => InitScreen(),
        '/home': (context) => RootTab(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupAgreementScreen(),
        '/report': (context) => CreateReport(),
        // '/signup/email': (context) => SignupInfoScreen(),
      },
    );
  }
}
