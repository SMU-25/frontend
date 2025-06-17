import 'package:flutter/material.dart';
import 'package:team_project_front/settings/component/custom_appbar.dart';
import 'package:team_project_front/settings/component/custom_notification_toggle_tile.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool allNotifications = false;
  bool careNotifications = false;
  bool marketingConsent = false;

  final List<Map<String, dynamic>> notificationSettings = [
    {
      'title': '전체 알림 수신',
      'subtitle': '케어 알림과 광고성 알림 모두 수신',
      'value': false,
    },
    {
      'title': '케어 알림 수신',
      'subtitle': '아이 열 관리 알림만 수신',
      'value': false,
    },
    {
      'title': '마케팅 수신 동의',
      'subtitle': '육아에 도움되는 광고 및 마케팅 알림 수신',
      'value': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: CustomAppbar(
          title: '알림 설정',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 16),
            ...notificationSettings.map((setting) {
              return CustomNotificationToggleTile(
                title: setting['title'],
                subtitle: setting['subtitle'],
                value: setting['value'],
                onChanged: (val) {
                  setState(() {
                    setting['value'] = val;

                    if (setting['title'] == '전체 알림 수신') {
                      allNotifications = val;
                    } else if (setting['title'] == '케어 알림 수신') {
                      careNotifications = val;
                    } else if (setting['title'] == '마케팅 수신 동의') {
                      marketingConsent = val;
                    }
                  });
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
