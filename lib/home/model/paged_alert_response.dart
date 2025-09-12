import 'package:team_project_front/home/model/alert.dart';

class PagedAlertResponse {
  final int totalElements;
  final int totalPages;
  final int size;
  final List<Alert> content;
  final int number;
  final bool first;
  final bool last;
  final bool empty;

  PagedAlertResponse({
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.content,
    required this.number,
    required this.first,
    required this.last,
    required this.empty,
  });

  factory PagedAlertResponse.fromJson(Map<String, dynamic> json) {
    return PagedAlertResponse(
      totalElements: json['totalElements'] as int,
      totalPages: json['totalPages'] as int,
      size: json['size'] as int,
      content:
          (json['content'] as List<dynamic>)
              .map((e) => Alert.fromJson(e as Map<String, dynamic>))
              .toList(),
      number: json['number'] as int,
      first: json['first'] as bool,
      last: json['last'] as bool,
      empty: json['empty'] as bool,
    );
  }
}
