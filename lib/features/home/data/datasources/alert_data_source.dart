import 'package:dio/dio.dart';
import 'package:team_project_front/core/network/dio_client.dart';
import 'package:team_project_front/features/home/data/models/alert.dart';
import 'package:team_project_front/features/home/data/models/notification.dart';
import 'package:team_project_front/features/home/data/models/notification_response.dart';
import 'package:team_project_front/features/home/data/models/page_result.dart';
import 'package:team_project_front/features/home/data/models/paged_alert_response.dart';
import 'package:team_project_front/features/home/domain/entities/alert_entity.dart';

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
    try {
      final res = await _dio.delete('/announcements/$id');

      if (res.statusCode == 200) {
        return true;
      } else {
        throw Exception('삭제 실패 (HTTP ${res.statusCode})');
      }
    } on DioException catch (e) {
      throw Exception('서버 요청 실패: ${e.message}');
    } catch (e) {
      throw Exception('공지 삭제 중 알 수 없는 오류 발생: $e');
    }
  }
}
