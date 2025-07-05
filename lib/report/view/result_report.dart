import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/common/component/temperature_chart_widget.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/report/model/report_info.dart';
import 'package:team_project_front/report/view/report.dart';
import 'package:team_project_front/settings/component/custom_appbar.dart';

class ResultReport extends StatelessWidget {
  final ReportInfo report;
  final List<String> allSymptoms;
  
  const ResultReport({
    required this.report,
    required this.allSymptoms,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedSymptoms = report.symptoms.toSet();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: CustomAppbar(
          title: '리포트 결과',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '아이의 증상 리포트입니다.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 15),
            _ChildSymptomsWidget(
              selectedSymptoms: selectedSymptoms,
              allSymptoms: allSymptoms,
            ),
            SizedBox(height: 20),
            if (report.etcSymptom.trim().isNotEmpty) ...[
              _EtcSymptomsWidget(etcSymptom: report.etcSymptom),
            ],
            SizedBox(height: 20),
            _DiagnosisWidget(illnesses: report.illnessTypes),
            SizedBox(height: 10),
            _SupplementaryExplanationWidget(outingRecord: report.outingRecord),
            SizedBox(height: 40),
            _ChartSectionWidget(title: '리포트 생성 시점 체온', chartType: ChartType.bodyTemp),
            _ChartSectionWidget(title: '리포트 생성 시점 온도', chartType: ChartType.roomTemp),
            _ChartSectionWidget(title: '리포트 생성 시점 습도', chartType: ChartType.humidity),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: NavigationButton(
          text: '완료',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => Report()),
            );
          },
        ),
      )
    );
  }
}

class _ChildSymptomsWidget extends StatelessWidget {
  final Set<String> selectedSymptoms;
  final List<String> allSymptoms;

  const _ChildSymptomsWidget({
    required this.selectedSymptoms,
    required this.allSymptoms,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '아이의 증상',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedSymptoms.map((symptom) {
            return Chip(
              avatar: Image.asset(
                'asset/img/symptoms/${allSymptoms.indexOf(symptom)}.png',
                width: 24, height: 24,
              ),
              label: Text(symptom),
              backgroundColor: MAIN_COLOR.withValues(alpha: 0.18),
              shape: StadiumBorder(
                side: BorderSide(color: MAIN_COLOR),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _EtcSymptomsWidget extends StatelessWidget {
  final String etcSymptom;

  const _EtcSymptomsWidget({
    required this.etcSymptom,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '기타 증상',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: MAIN_COLOR.withValues(alpha: 0.5),
              width: 4,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            etcSymptom.trim(),
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class _DiagnosisWidget extends StatelessWidget {
  final List<String> illnesses;

  const _DiagnosisWidget({
    required this.illnesses,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이전 진단 질환',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: illnesses.map((illness) {
            return Chip(
              label: Text(illness),
              labelStyle: TextStyle(fontWeight: FontWeight.w900),
              backgroundColor: MAIN_COLOR.withValues(alpha: 0.18),
              shape: StadiumBorder(
                side: BorderSide(color: MAIN_COLOR),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SupplementaryExplanationWidget extends StatelessWidget {
  final String outingRecord;

  const _SupplementaryExplanationWidget({
    required this.outingRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: '보충 설명',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            children: [
              TextSpan(
                text: '(AI가 설명한 내용입니다.)',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: MAIN_COLOR.withValues(alpha: 0.5), width: 4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            outingRecord.trim().isNotEmpty
                ? outingRecord.trim()
                : '입력된 외출 기록이 없습니다.',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class _ChartSectionWidget extends StatelessWidget {
  final String title;
  final ChartType chartType;

  const _ChartSectionWidget({
    required this.title,
    required this.chartType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ),
        SizedBox(height: 30),
        TemperatureChartWidget(chartType: chartType),
        SizedBox(height: 40),
      ],
    );
  }
}
