class NotificationItem {
  final int notificationId;
  final String type;
  final String message;
  final double? fever;
  final double? temperature;
  final double? humidity;
  final DateTime createdAt;
  final String childName;
  final bool read;

  NotificationItem({
    required this.notificationId,
    required this.type,
    required this.message,
    this.fever,
    this.temperature,
    this.humidity,
    required this.createdAt,
    required this.childName,
    required this.read,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      notificationId: json['notificationId'] as int,
      type: json['type'] as String,
      message: json['message'] as String,
      fever: (json['fever'] as num?)?.toDouble(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      childName: json['childName'] as String,
      read: json['read'] as bool,
    );
  }
}
