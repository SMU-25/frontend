import 'package:team_project_front/core/network/dio_client.dart';
import 'package:team_project_front/features/home/data/models/alert.dart';
import 'package:team_project_front/features/home/data/models/notification.dart';
import 'package:team_project_front/features/home/data/models/notification_response.dart';
import 'package:team_project_front/features/home/data/models/page_result.dart';
import 'package:team_project_front/features/home/data/models/paged_alert_response.dart';

class AlertDataSource {
  final _dio = buildAuthedDio();

  Future<PageResult<NotificationItem, int>> fetchNotifications(
    int? cursor,
  ) async {
    final res = await _dio.get(
      '/notifications',
      queryParameters: {'cursor': cursor, 'size': 20},
    );
    if (res.statusCode != 200) {
      throw Exception('알림 조회 실패 (HTTP ${res.statusCode})');
    }
    final data = NotificationResponse.fromJson(
      res.data['result'] as Map<String, dynamic>,
    );
    return PageResult(
      items: data.content,
      nextKey: data.nextCursor,
      hasNext: data.hasNext,
    );
  }

  Future<PageResult<Alert, int>> fetchAnnouncements(
    int? page, {
    AlertType? type,
  }) async {
    String typeToQuery(AlertType t) => t.name.toLowerCase();

    final currentPage = page ?? 0;

    final res = await _dio.get(
      '/announcements',
      queryParameters: {
        if (type != null) 'type': typeToQuery(type),
        'page': currentPage,
        'size': 20,
      },
    );
    if (res.statusCode != 200) {
      throw Exception('공지 조회 실패 (HTTP ${res.statusCode})');
    }
    final data = PagedAlertResponse.fromJson(
      res.data['result'] as Map<String, dynamic>,
    );
    final nextPage = currentPage + 1;
    final hasNext = !data.last && nextPage < data.totalPages;

    return PageResult(
      items: data.content,
      nextKey: hasNext ? nextPage : null,
      hasNext: hasNext,
    );
  }

  Future<bool> deleteAnnouncement(int id) async {
    final res = await _dio.delete('/announcements/$id');
    return res.statusCode == 200;
  }
}
