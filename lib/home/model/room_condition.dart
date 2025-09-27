import 'package:json_annotation/json_annotation.dart';

part 'room_condition.g.dart';

@JsonSerializable()
class RoomCondition {
  @JsonKey(name: 'temperature')
  final double? airTemperature;
  final double? humidity;
  final DateTime? createdAt;

  RoomCondition({
    required this.airTemperature,
    required this.humidity,
    required this.createdAt,
  });

  factory RoomCondition.fromJson(Map<String, dynamic> json) =>
      _$RoomConditionFromJson(json);

  Map<String, dynamic> toJson() => _$RoomConditionToJson(this);
}
