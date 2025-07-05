class FeverReport {
  // 리포트 고유 ID
  final int? reportId;
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

  FeverReport({
    this.reportId,
    required this.childId,
    required this.createdAt,
    required this.symptoms,
    required this.etcSymptom,
    required this.outingRecord,
    required this.illnessTypes,
  });
}
