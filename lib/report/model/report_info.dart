import 'package:fl_chart/fl_chart.dart';
import 'package:json_annotation/json_annotation.dart';
part 'report_info.g.dart';

@JsonSerializable(createToJson: false)
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
  final List<String> illnesses;
  // AI 분석 설명
  final String special;
  @JsonKey(fromJson: ReportStats.fromJson)
  final ReportStats? day1;
  @JsonKey(fromJson: ReportStats.fromJson)
  final ReportStats? day3;
  @JsonKey(fromJson: ReportStats.fromJson)
  final ReportStats? day7;

  ReportInfo({
    required this.reportId,
    required this.childId,
    required this.createdAt,
    required this.symptoms,
    required this.etcSymptom,
    required this.outingRecord,
    required this.illnesses,
    required this.special,
    this.day1,
    this.day3,
    this.day7,
  });
  factory ReportInfo.fromJson(Map<String, dynamic> json) =>
      _$ReportInfoFromJson(json);
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
        if (e[key] == null) return 0.0;
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
