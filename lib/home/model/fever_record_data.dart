import 'package:json_annotation/json_annotation.dart';

part 'fever_record_data.g.dart';

enum IsHuman {
  @JsonValue("HUMAN")
  human,

  @JsonValue("NOT_HUMAN")
  notHuman,
}

@JsonSerializable()
class FeverRecord {
  final double? fever;
  final DateTime? createdAt;
  final IsHuman state;

  FeverRecord({
    required this.fever,
    required this.createdAt,
    required this.state,
  });

  factory FeverRecord.fromJson(Map<String, dynamic> json) =>
      _$FeverRecordFromJson(json);

  /// FeverRecord → JSON
  Map<String, dynamic> toJson() => _$FeverRecordToJson(this);
}
