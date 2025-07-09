import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class AlertScreen extends StatelessWidget {
  const AlertScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '알람',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.grey[350],
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.black,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                unselectedLabelColor: Colors.grey,
                tabs: const [Tab(text: '케어'), Tab(text: '공지/이벤트')],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [_CareAlerts(), Center(child: Text('공지/이벤트 탭'))],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  return DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: Text('알람', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          TabBarView(
            children: [_CareAlerts(), Center(child: Text('공지/이벤트 탭'))],
          ),
        ],
      ),
    ),
  );
}

class _CareAlerts extends StatelessWidget {
  final List<Map<String, dynamic>> alerts = [
    {'temp': 36.5, 'status': '정상'},
    {'temp': 37.5, 'status': '미열'},
    {'temp': 38.5, 'status': '고열'},
    {'temp': 36.5, 'status': '정상'},
    {'temp': 37.5, 'status': '미열'},
    {'temp': 38.5, 'status': '고열'},
    {'temp': 38.5, 'status': '고열'},
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case '정상':
        return MAIN_COLOR;
      case '미열':
        return MILD_FEVER_COLOR;
      case '고열':
        return HIGH_FEVER_COLOR;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      itemCount: alerts.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        final alert = alerts[index];
        final temp = alert['temp'];
        final status = alert['status'];
        final color = _getStatusColor(status);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('체온 알림', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 14),
                children: [
                  TextSpan(text: '준형이 현재 체온은 '),
                  TextSpan(
                    text: '$temp℃, ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '$status',
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '입니다.'),
                ],
              ),
            ),
            SizedBox(height: 6),
            Text(
              '00/00 00:00',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        );
      },
    );
  }
}
