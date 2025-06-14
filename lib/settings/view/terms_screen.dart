import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/settings/component/custom_appbar.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> settingsItems = [
      {'title': '서비스 이용약관', 'onTap': () {}},
      {'title': '개인정보 처리방침', 'onTap': () => {}},
      {'title': '위치정보 서비스 이용약관', 'onTap': () {}},
    ];

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: CustomAppbar(
            title: '약관',
          ),
      ),
      body: _SettingsListView(
        settingsItems: settingsItems,
      ),
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
              onTap: item['onTap'],
            ),
            Divider(
              color: ICON_GREY_COLOR,
              height: 0.5,
              thickness: 1,
            ),
          ],
        );
      },
    );
  }
}

