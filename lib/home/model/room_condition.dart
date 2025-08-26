class RoomCondition {
  final double? airTemperature;
  final double? humidity;
  final DateTime? createdAt;

  RoomCondition({
    required this.airTemperature,
    required this.humidity,
    required this.createdAt,
  });
  factory RoomCondition.fromJson(Map<String, dynamic> j) => RoomCondition(
    airTemperature: (j['temperature'] as num).toDouble(),
    humidity: (j['humidity'] as num).toDouble(),
    createdAt: DateTime.parse(j['createdAt'] as String),
  );
}
