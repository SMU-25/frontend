import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/common/component/temperature_chart_widget.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/report/model/report_info.dart';
import 'package:team_project_front/report/view/report.dart';
import 'package:team_project_front/settings/component/custom_appbar.dart';

class ResultReport extends StatefulWidget {
  final int reportId;
  final ReportInfo report;
  final List<String> allSymptoms;
  final bool showBackButton;
  
  const ResultReport({
    required this.reportId,
    required this.report,
    required this.allSymptoms,
    this.showBackButton = true,
    super.key,
  });

  @override
  State<ResultReport> createState() => _ResultReportState();
}

class _ResultReportState extends State<ResultReport> {
  late Future<ReportInfo> reportFuture;

  // 임시 Access Token (추후 FlutterSecureStorage 등으로 교체 예정)
  final String accessToken = 'Bearer ACCESS_TOKEN';

  @override
  void initState() {
    super.initState();
    reportFuture = fetchReport();
  }

  Future<ReportInfo> fetchReport() async {
    try {
      final response = await Dio().get(
        '$base_URL/reports/${widget.reportId}',
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
        ),
      );

      if(response.statusCode == 200 && response.data['isSuccess']) {
        return ReportInfo.fromJson(response.data['result']);
      } else {
        throw Exception('리포트 불러오기 실패');
      }
    } catch(e) {
      print('예외 발생!');
      print('$e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: CustomAppbar(
          title: '리포트 결과',
          showBackButton: widget.showBackButton,
        ),
      ),
      body: FutureBuilder<ReportInfo>(
        future: reportFuture,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if(snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          } else if(!snapshot.hasData) {
            return Center(child: Text('리포트를 불러올 수 없습니다.'));
          }

          final report = snapshot.data!;
          final selectedSymptoms = report.symptoms.toSet();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '아이의 증상 리포트입니다.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 15),
                _ChildSymptomsWidget(
                  selectedSymptoms: selectedSymptoms.map((symptom) => symptom.replaceAll('_', ' ')).toSet(),
                  allSymptoms: widget.allSymptoms,
                ),
                const SizedBox(height: 20),
                if (report.etcSymptom.trim().isNotEmpty)
                  _EtcSymptomsWidget(etcSymptom: report.etcSymptom),
                const SizedBox(height: 20),
                _DiagnosisWidget(illnesses: report.illnesses),
                const SizedBox(height: 10),
                _SupplementaryExplanationWidget(special: report.special),
                const SizedBox(height: 40),
                _ChartSectionWidget(
                  title: '리포트 생성 시점 체온',
                  chartType: ChartType.bodyTemp,
                  chartData: {
                    PeriodType.day1: report.day1?.toFeverSpots() ?? [],
                    PeriodType.day3: report.day3?.toFeverSpots() ?? [],
                    PeriodType.day7: report.day7?.toFeverSpots() ?? [],
                  },
                  createdAt: report.createdAt,
                ),
                _ChartSectionWidget(
                  title: '리포트 생성 시점 방 온도',
                  chartType: ChartType.roomTemp,
                  chartData: {
                    PeriodType.day1: report.day1?.toTemperatureSpots() ?? [],
                    PeriodType.day3: report.day3?.toTemperatureSpots() ?? [],
                    PeriodType.day7: report.day7?.toTemperatureSpots() ?? [],
                  },
                  createdAt: report.createdAt,
                ),
                _ChartSectionWidget(
                  title: '리포트 생성 시점 방 습도',
                  chartType: ChartType.humidity,
                  chartData: {
                    PeriodType.day1: report.day1?.toHumiditySpots() ?? [],
                    PeriodType.day3: report.day3?.toHumiditySpots() ?? [],
                    PeriodType.day7: report.day7?.toHumiditySpots() ?? [],
                  },
                  createdAt: report.createdAt,
                ),
              ],
            ),
          );
        }
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
  final String special;

  const _SupplementaryExplanationWidget({
    required this.special,
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
            special.trim().isNotEmpty
                ? special.trim()
                : '보충 설명이 없습니다.',
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
  final Map<PeriodType, List<FlSpot>> chartData;
  final DateTime createdAt;

  const _ChartSectionWidget({
    required this.title,
    required this.chartType,
    required this.chartData,
    required this.createdAt,
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
        TemperatureChartWidget(
          chartType: chartType,
          chartData: chartData,
          createdAt: createdAt,
        ),
        SizedBox(height: 40),
      ],
    );
  }
}
