import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_template.dart';
import 'package:team_project_front/common/view/root_tab.dart';
import 'package:team_project_front/init/view/init.dart';
import 'package:team_project_front/login/view/login.dart';
import 'package:team_project_front/report/view/report.dart';
import 'package:team_project_front/signup/view/signup_agreement.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// 백그라운드/종료 상태에서 메시지 핸들러
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDateFormatting();
  KakaoSdk.init(nativeAppKey: 'b3565aae8a5f99df7052455a2917cec7');
  // 백그라운드 핸들러 등록
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  await FlutterNaverMap().init(
    clientId: 'zyezii413y',
    onAuthFailed: (ex) {
      switch (ex) {
        case NQuotaExceededException(:final message):
          print("사용량 초과 (message: $message)");
          break;
        case NUnauthorizedClientException() ||
            NClientUnspecifiedException() ||
            NAnotherAuthFailedException():
          print("인증 실패: $ex");
          break;
      }
    },
  );

  runApp(ProviderScope(child: _App()));
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSans',
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),

      // home: RootTab(),
      // Named Routes 적용 화면 개발시 initialRoute를 바꿔주면서 진행하면 편리합니다.
      // ex) login 화면 개발 중이라면 initialRoute: '/login',
      initialRoute: '/',
      routes: {
        '/': (context) => InitScreen(),
        '/home': (context) => RootTab(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupAgreementScreen(),
        '/report': (context) => Report(),
      },
    );
  }
}
