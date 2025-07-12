import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/yes_or_no_dialog.dart';
import 'package:team_project_front/common/const/colors.dart';
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
        onPressedYes: () {
          // 로그아웃 처리 로직
        },
        yesText: '예',
        noText: '아니오',
      ),
    );
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
          withdrawUser(context);
        },
        yesText: '예',
        noText: '아니오',
      ),
    );
  }
}

// 추후에 accessToken FlutterSecureStorage에서 가져오도록 변경 예정
final String accessToken = 'Bearer ACCESS_TOKEN';

Future<void> withdrawUser(BuildContext context) async {
  final dio = Dio();

  try {
    Navigator.of(context).pop();

    final response = await dio.delete(
      'https://momfy.kr/api/my',
      options: Options(headers: {
        'Authorization': accessToken,
      }),
    );

    if(response.data['isSuccess'] == true) {
      // 토큰 삭제
      //await storage.deleteAll();
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원 탈퇴가 완료되었습니다.')),
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('탈퇴 실패: ${response.data['message']}')),
          );
        }
      }
    }
  } catch(e) {
    print('회원 탈퇴 오류: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('탈퇴 중 오류가 발생했습니다.')),
      );
    }
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