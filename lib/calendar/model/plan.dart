class Plan {
  // 식별 가능한 ID
  final int id;
  // 제목
  final String title;
  // 내용
  final String content;
  // 날짜
  final DateTime date;
  // 일정 생성날짜시간
  final DateTime createdAt;

  Plan({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.createdAt,
  });
}