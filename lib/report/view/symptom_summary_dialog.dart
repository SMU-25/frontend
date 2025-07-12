import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/report/model/report_info.dart';
import 'package:team_project_front/report/view/result_report.dart';

class SymptomSummaryDialog extends StatelessWidget {
  final Set<String> selectedSymptoms;
  final String etcSymptom;
  final String outingRecord;
  final List<String> allSymptoms;

  const SymptomSummaryDialog({
    super.key,
    required this.selectedSymptoms,
    required this.etcSymptom,
    required this.outingRecord,
    required this.allSymptoms,
  });

  void _navigateToResultReport(BuildContext context) async {
    try {
      final report = await createReport(
        // 홈화면에서 아이 선택 후 리포트 생성할 것이므로
        // childId는 현재 임의로 설정
        childId: 15,
        symptoms: selectedSymptoms.toList(),
        etcSymptom: etcSymptom,
        outingRecord: outingRecord,
      );

      if(report == null) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResultReport(
            reportId: report.reportId,
            report: report,
            allSymptoms: allSymptoms,
            showBackButton: false,
         ),
        ),
      );
    } catch(e) {
      print('리포트 생성 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('리포트 생성에 실패했어요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: EdgeInsets.all(16),
      contentPadding: EdgeInsets.symmetric(horizontal: 24),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('아이의 증상', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          TextButton(
            onPressed: () => _navigateToResultReport(context),
            child: Text('확인', style: TextStyle(color: MAIN_COLOR, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChildSymptomsWidget(
            selectedSymptoms: selectedSymptoms,
            allSymptoms: allSymptoms,
          ),
          SizedBox(height: 16),
          if (etcSymptom.trim().isNotEmpty) ...[
            InfoSection(
              title: '기타 증상',
              content: etcSymptom,
            ),
          ],
          SizedBox(height: 16),
          if (outingRecord.trim().isNotEmpty) ...[
            InfoSection(
              title: '외출 기록',
              content: outingRecord,
            ),
          ],
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

Future<ReportInfo?> createReport({
  required int childId,
  required List<String> symptoms,
  required String etcSymptom,
  required String outingRecord,
}) async {
  final dio = Dio();

  final convertedSymptoms = symptoms.map((s) => s.replaceAll(' ', '_')).toList();

  // 추후에 accessToken FlutterSecureStorage에서 가져오도록 변경 예정
  final accessToken = 'Bearer ACCESS_TOKEN';

  final response = await dio.post(
    '$base_URL/reports/$childId',
    data: {
      'symptoms': convertedSymptoms,
      'etc_symptom': etcSymptom,
      'outing': outingRecord,
    },
    options: Options(
      headers: {
        'Authorization': accessToken,
      },
    ),
  );

  final result = response.data['result'];

  return ReportInfo(
    reportId: result['reportId'],
    childId: childId,
    createdAt: DateTime.parse(result['createdAt']),
    symptoms: List<String>.from(result['symptoms']),
    etcSymptom: result['etc_symptom'] ?? '',
    outingRecord: result['outing'] ?? '',
    illnessTypes: [], // 추후 api 변경 되면 받아올 예정.
    day1: ReportStats.fromJson(result['day1']),
    day3: ReportStats.fromJson(result['day3']),
    day7: ReportStats.fromJson(result['day7']),
  );
}

class ChildSymptomsWidget extends StatelessWidget {
  final Set<String> selectedSymptoms;
  final List<String> allSymptoms;

  const ChildSymptomsWidget({
    super.key,
    required this.selectedSymptoms,
    required this.allSymptoms,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: selectedSymptoms.map((symptom) {
        return Chip(
          avatar: Image.asset(
            'asset/img/symptoms/${allSymptoms.indexOf(symptom)}.png',
            width: 24,
            height: 24,
          ),
          label: Text(symptom),
          backgroundColor: MAIN_COLOR.withValues(alpha: 0.18),
          labelStyle: TextStyle(fontWeight: FontWeight.w700),
          shape: StadiumBorder(
            side: BorderSide(color: MAIN_COLOR),
          ),
        );
      }).toList(),
    );
  }
}

class InfoSection extends StatelessWidget {
  final String title;
  final String content;

  const InfoSection({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w900)),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: MAIN_COLOR.withValues(alpha: 0.5),
              width: 4,
            ),
          ),
          child: Text(
            content.trim(),
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
