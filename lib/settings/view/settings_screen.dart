import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/settings/component/custom_appbar.dart';
import 'package:team_project_front/settings/view/terms_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> settingsItems = [
      {'title': '알림 설정', 'onTap': () {}},
      {'title': '약관', 'onTap': () => onPressedTerms(context)},
      {'title': '버전 정보', 'trailing': '1.0.0', 'onTap': null},
      {'title': '로그아웃', 'onTap': () {}},
      {'title': '회원 탈퇴', 'onTap': () {}},
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