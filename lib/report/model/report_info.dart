import 'package:fl_chart/fl_chart.dart';

class ReportInfo {
  // 리포트 고유 ID
  final int reportId;
  // 아이 고유 ID (필수)
  final int childId;
  // 리포트 생성일
  final DateTime createdAt;
  // 주요 증상들
  final List<String> symptoms;
  // 기타 증상 텍스트
  final String etcSymptom;
  // 외출 기록
  final String outingRecord;
  // 진단 질환들
  final List<String> illnessTypes;

  final ReportStats? day1;
  final ReportStats? day3;
  final ReportStats? day7;

  ReportInfo({
    required this.reportId,
    required this.childId,
    required this.createdAt,
    required this.symptoms,
    required this.etcSymptom,
    required this.outingRecord,
    required this.illnessTypes,
    this.day1,
    this.day3,
    this.day7,
  });

  factory ReportInfo.fromJson(Map<String, dynamic> json) {
    return ReportInfo(
      reportId: json['reportId'] ?? 0,
      childId: json['childId'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      symptoms: List<String>.from(json['symptoms'] ?? []),
      etcSymptom: json['etc_symptom'] ?? '',
      outingRecord: json['outing'] ?? '',
      illnessTypes: List<String>.from(json['illnessTypes'] ?? []),
      day1: json['day1'] != null ? ReportStats.fromJson(json['day1']) : null,
      day3: json['day3'] != null ? ReportStats.fromJson(json['day3']) : null,
      day7: json['day7'] != null ? ReportStats.fromJson(json['day7']) : null,
    );
  }
}

class ReportStats {
  final List<double> fever;
  final List<double> humidity;
  final List<double> temperature;

  ReportStats({
    required this.fever,
    required this.humidity,
    required this.temperature,
  });

  static ReportStats fromJson(Map<String, dynamic> json) {
    List<double> parseAvgList(List<dynamic> rawList, String key) {
      return rawList.map((e) {
        if(e[key] == null) return 0.0;
        return (e[key] as num).toDouble();
      }).toList();
    }

    return ReportStats(
      fever: parseAvgList(json['fever'], 'avgfever'),
      humidity: parseAvgList(json['humidity'], 'avghumidity'),
      temperature: parseAvgList(json['temperature'], 'avgtemperature'),
    );
  }

  List<FlSpot> toFeverSpots() {
    return fever
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
  }

  List<FlSpot> toHumiditySpots() {
    return humidity
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
  }

  List<FlSpot> toTemperatureSpots() {
    return temperature
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
  }
}