// alert.dart
import 'package:json_annotation/json_annotation.dart';

part 'alert.g.dart';

enum AlertType { notice, event }

@JsonSerializable()
class Alert {
  final int id;

  // 서버는 대문자 NOTICE/EVENT → Dart enum으로 파싱
  // Dart → 서버 전송 시에도 대문자로 직렬화
  @JsonKey(fromJson: _alertTypeFromJson, toJson: _alertTypeToJson)
  final AlertType type;

  final String title;
  final String content;
  final bool pinned;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Alert({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.pinned,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  /// JSON → Alert
  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);

  /// Alert → JSON
  Map<String, dynamic> toJson() => _$AlertToJson(this);
}

/// 대문자 문자열 → enum
AlertType _alertTypeFromJson(String value) {
  switch (value.toUpperCase()) {
    case 'NOTICE':
      return AlertType.notice;
    case 'EVENT':
      return AlertType.event;
    default:
      throw ArgumentError('Unknown AlertType: $value');
  }
}

/// enum → 대문자 문자열
String _alertTypeToJson(AlertType type) => type.name.toUpperCase();
