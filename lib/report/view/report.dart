import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/report/component/report_card.dart';
import 'package:team_project_front/report/model/report_info.dart';
import 'package:team_project_front/report/view/change_report.dart';
import 'package:team_project_front/report/view/create_report.dart';
import 'package:team_project_front/report/view/result_report.dart';
import 'package:team_project_front/settings/component/custom_appbar.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final List<ReportInfo> reportData = [
    ReportInfo(
      reportId: 1,
      childId: 101,
      createdAt: DateTime(2025, 7, 5),
      symptoms: ['발열', '구토', '피부 발진'],
      etcSymptom: '복통이 심함',
      outingRecord: '2025년 7월 5일 오후 1시~3시 공원',
      illnessTypes: ['아토피'],
    ),
    ReportInfo(
      reportId: 2,
      childId: 101,
      createdAt: DateTime(2025, 7, 3),
      symptoms: ['발열', '콧물', '실신'],
      etcSymptom: '고열 지속',
      outingRecord: '2025년 7월 3일 백화점 방문',
      illnessTypes: ['천식'],
    ),
  ];

  final List<String> allSymptoms = [
    '발열', '구토', '경련', '코피', '설사',
    '피부 발진', '실신', '호흡곤란', '기침', '콧물', '황달'
  ];

  String formatDate(DateTime date) {
    return DateFormat('yyyy년 M월 d일').format(date);
  }

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
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ResultReport(
                        report: report,
                        allSymptoms: allSymptoms,
                      ),
                    ),
                  );
                },
                child: ReportCard(
                  createdAt: formatDate(report.createdAt),
                  content: report.symptoms.join(', '),
                  onEditPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChangeReport(report: report),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
    );
  }
}
