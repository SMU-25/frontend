class NotificationItemEntity {
  final int id;
  final String type;
  final String message;
  final double? fever;
  final double? temperature;
  final double? humidity;
  final DateTime createdAt;
  final String childName;
  final bool read;

  const NotificationItemEntity({
    required this.id,
    required this.type,
    required this.message,
    this.fever,
    this.temperature,
    this.humidity,
    required this.createdAt,
    required this.childName,
    required this.read,
  });
}
