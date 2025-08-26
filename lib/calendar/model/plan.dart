class Plan {
  // 식별 가능한 ID
  final int calendarId;
  // 제목
  final String title;
  // 내용
  final String content;
  // 날짜
  final DateTime date;
  // 일정 생성날짜시간
  final String recordDate;

  Plan({
    required this.calendarId,
    required this.recordDate,
    required this.date,
    required this.title,
    required this.content,
  });

  factory Plan.fromMap(Map<String, dynamic> json) {
    return Plan(
      calendarId: json['calendarId'] as int,
      recordDate: json['recordDate'] as String,
      date: DateTime.parse(json['scheduleDate'] as String),
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }
}