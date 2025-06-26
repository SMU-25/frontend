import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/common/component/temperature_chart_widget.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/settings/component/custom_appbar.dart';

class ResultReport extends StatelessWidget {
  final Set<String> selectedSymptoms;
  final String etcSymptom;
  final List<String> illnesses; // API 요청 예정
  final List<String> allSymptoms;
  final String outingRecord;
  
  const ResultReport({
    required this.selectedSymptoms,
    required this.etcSymptom,
    required this.illnesses,
    required this.allSymptoms,
    required this.outingRecord,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 20),
            if (etcSymptom.trim().isNotEmpty) ...[
              Text('기타 증상',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
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
                child: Text(etcSymptom),
              ),
            ],
            SizedBox(height: 20),
            Text('이전 진단 질환',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
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
            SizedBox(height: 10),
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
              )
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: MAIN_COLOR.withValues(alpha: 0.5), width: 4),
                borderRadius: BorderRadius.circular(16),
              ),

              // TODO: AI 도입하기 전 일단 외출 기록을 그대로 받아옴.
              child: Text(
                outingRecord.trim().isNotEmpty
                  ? outingRecord.trim()
                  : '입력된 외출 기록이 없습니다.',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: Text(
                '발열 시점 이후 체온',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ),
            SizedBox(height: 30),
            TemperatureChartWidget(chartType: ChartType.bodyTemp),
            SizedBox(height: 40),
            Center(
              child: Text(
                '발열 시점 이후 방 온도',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ),
            SizedBox(height: 30),
            TemperatureChartWidget(chartType: ChartType.roomTemp),
            SizedBox(height: 40),
            Center(
              child: Text(
                '발열 시점 이후 방 습도',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ),
            SizedBox(height: 30),
            TemperatureChartWidget(chartType: ChartType.humidity),
            SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: NavigationButton(
          text: '완료',
          onPressed: () {},
        ),
      )
    );
  }
}
