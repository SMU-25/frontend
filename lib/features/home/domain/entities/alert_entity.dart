enum AlertType { notice, event }

class AlertEntity {
  final AlertType type;
  final int id;
  final String title;
  final String content;
  final bool pinned;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AlertEntity({
    required this.type,
    required this.id,
    required this.title,
    required this.pinned,
    required this.content,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });
}
