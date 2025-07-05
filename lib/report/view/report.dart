import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/report/component/report_card.dart';
import 'package:team_project_front/report/view/create_report.dart';
import 'package:team_project_front/settings/component/custom_appbar.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  List<Map<String, String>> reportData = [
    {'createdAt': '2025년 7월 5일', 'content': '발열, 구토, 피부 발진'},
    {'createdAt': '2025년 7월 3일', 'content': '발열, 콧물, 실신'},
    {'createdAt': '2025년 7월 2일', 'content': '피부 발진'},
    {'createdAt': '2025년 7월 1일', 'content': '기침, 고열'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => CreateReport())
          );
        },
        elevation: 0,
        backgroundColor: Colors.transparent,
        highlightElevation: 0,
        child: Icon(
          size: 60,
          Icons.add_circle,
          color: MAIN_COLOR,
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: CustomAppbar(
          title: '발열 리포트',
        ),
      ),
        body: reportData.isEmpty
            ? Center(
          child: Text(
            '생성된 발열 리포트가 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        )
            : ListView.builder(
          itemCount: reportData.length,
          itemBuilder: (context, index) {
            final report = reportData[index];
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: HIGH_FEVER_COLOR,
                child: Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) {
                setState(() {
                  reportData.removeAt(index);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("삭제되었습니다.")),
                );
              },
              child: ReportCard(
                createdAt: report['createdAt']!,
                content: report['content']!,
              ),
            );
          },
        ),
    );
  }
}
