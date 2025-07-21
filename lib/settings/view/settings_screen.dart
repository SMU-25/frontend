import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/yes_or_no_dialog.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/common/utils/secure_storage_service.dart';
import 'package:team_project_front/main.dart';
import 'package:team_project_front/settings/component/custom_appbar.dart';
import 'package:team_project_front/settings/view/notification_settings_screen.dart';
import 'package:team_project_front/settings/view/terms_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> settingsItems = [
      {'title': '알림 설정', 'onTap': () => onPressedNotification(context)},
      {'title': '약관', 'onTap': () => onPressedTerms(context)},
      {'title': '버전 정보', 'trailing': '1.0.0', 'onTap': null},
      {'title': '로그아웃', 'onTap': () => onPressedLogout(context)},
      {'title': '회원 탈퇴', 'onTap': () => onPressedWithdraw(context)},
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: CustomAppbar(
          title: '설정',
        ),
      ),
      body: _SettingsListView(
          settingsItems: settingsItems,
      ),
    );
  }

  void onPressedTerms(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TermsScreen()),
    );
  }
  
  void onPressedNotification(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => NotificationSettingsScreen())
    );
  }

  void onPressedLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => YesOrNoDialog(
        title: '로그아웃',
        content: '정말 로그아웃 하시겠습니까?',
        onPressedYes: () async {
          Navigator.of(context).pop();
          await logoutUser();
        },
        yesText: '예',
        noText: '아니오',
      ),
    );
  }

  Future<void> logoutUser() async {
    final dio = Dio();
    final token = await SecureStorageService.getAccessToken();

    if (token == null) {
      print('토큰이 없습니다. 로그아웃 불가');
      return;
    }

    final accessToken = 'Bearer $token';

    try {
      final response = await dio.post(
        '$base_URL/auth/logout',
        options: Options(headers: {
          'Authorization': accessToken,
        }),
      );

      if (response.data['isSuccess'] == true) {
        await SecureStorageService.deleteAccessToken();
        // refreshToken 관련 로직 추가 예정

        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/login',
              (route) => false,
        );
      } else {
        print('로그아웃 실패: ${response.data['message']}');
      }
    } catch(e) {
      print('로그아웃 오류: $e');
    }
  }

  void onPressedWithdraw(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => YesOrNoDialog(
        title: '회원 탈퇴',
        content:
          '회원 탈퇴 시 기록하신 모든 데이터가\n'
          '삭제되어 복구가 불가능합니다.\n'
          '정말 탈퇴하시겠습니까?',
        onPressedYes: () async {
          Navigator.of(context).pop();
          await withdrawUser();
        },
        yesText: '예',
        noText: '아니오',
      ),
    );
  }
}

Future<void> withdrawUser() async {
  final dio = Dio();
  final token = await SecureStorageService.getAccessToken();

  if (token == null) {
    print('토큰이 없습니다. 탈퇴 불가');
    return;
  }

  final accessToken = 'Bearer $token';

  try {
    final response = await dio.delete(
      '$base_URL/my',
      options: Options(headers: {
        'Authorization': accessToken,
      }),
    );

    if (response.data['isSuccess'] == true) {
      await SecureStorageService.deleteAccessToken();
      // refreshToken 관련 로직 추가 예정

      navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
    } else {
      print('탈퇴 실패: ${response.data['message']}');
    }
  } catch(e) {
    print('회원 탈퇴 오류: $e');
  }
}

class _SettingsListView extends StatelessWidget {
  final List<Map<String, dynamic>> settingsItems;

  const _SettingsListView({
    required this.settingsItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: settingsItems.length,
      itemBuilder: (context, index) {
        final item = settingsItems[index];

        return Column(
          children: [
            Divider(
              color: ICON_GREY_COLOR,
              height: 0.5,
              thickness: 1,
            ),
            ListTile(
              title: Text(
                item['title'],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: item['trailing'] != null ? Text(
                item['trailing'],
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: ICON_GREY_COLOR,
                    fontSize: 15
                ),
              ) : null,
              onTap: item['onTap'],
            ),
            Divider(
              color: ICON_GREY_COLOR,
              height: 0.5,
              thickness: 1,
            ),
            if(item['title'] == '로그아웃' || item['title'] == '버전 정보')
              SizedBox(height: 64),
          ],
        );
      },
    );
  }
}