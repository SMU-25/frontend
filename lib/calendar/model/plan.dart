import 'package:json_annotation/json_annotation.dart';
part 'plan.g.dart';

@JsonSerializable()
class Plan {
  // 식별 가능한 ID
  final int calendarId;
  // 제목
  final String title;
  // 내용
  final String content;

  @JsonKey(name: 'scheduleDate')
  final DateTime? date;
  // 일정 생성날짜시간
  final String? recordDate;

  Plan({
    required this.calendarId,
    required this.recordDate,
    required this.date,
    required this.title,
    required this.content,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);

  /// Plan → JSON
  Map<String, dynamic> toJson() => _$PlanToJson(this);
}
