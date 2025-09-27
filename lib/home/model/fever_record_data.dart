import 'package:json_annotation/json_annotation.dart';

part 'fever_record_data.g.dart';

@JsonSerializable()
class FeverRecord {
  final double? fever;
  final DateTime? createdAt;

  FeverRecord({required this.fever, required this.createdAt});
  factory FeverRecord.fromJson(Map<String, dynamic> json) =>
      _$FeverRecordFromJson(json);

  /// FeverRecord → JSON
  Map<String, dynamic> toJson() => _$FeverRecordToJson(this);
}
