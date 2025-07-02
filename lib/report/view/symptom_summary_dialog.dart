import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';
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

  void _navigateToResultReport(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResultReport(
          selectedSymptoms: selectedSymptoms,
          etcSymptom: etcSymptom,
          illnesses: ['아토피', '천식'], // API 요청 예정
          allSymptoms: allSymptoms,
          outingRecord: outingRecord,
        ),
      ),
    );
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
