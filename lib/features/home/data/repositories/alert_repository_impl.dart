import 'package:team_project_front/features/home/data/datasources/alert_data_source.dart';
import 'package:team_project_front/features/home/data/models/alert.dart';
import 'package:team_project_front/features/home/data/models/notification.dart';
import 'package:team_project_front/features/home/data/models/page_result.dart';
import 'package:team_project_front/features/home/domain/entities/alert_entity.dart';
import 'package:team_project_front/features/home/domain/entities/notification_entiry.dart';
import 'package:team_project_front/features/home/domain/entities/page_result_entity.dart';
import 'package:team_project_front/features/home/domain/repositories/alert_repository.dart';

class AlertRepositoryImpl implements AlertRepository {
  final AlertDataSource _remoteDataSource;

  AlertRepositoryImpl(this._remoteDataSource);

  @override
  Future<PageResultEntity<NotificationItemEntity, int>> getNotifications({
    int? cursor,
  }) async {
    final PageResult<NotificationItem, int> result = await _remoteDataSource
        .fetchNotifications(cursor);

    final convertedItems = result.items.map((e) => e.toEntity()).toList();

    return PageResultEntity<NotificationItemEntity, int>(
      items: convertedItems,
      nextKey: result.nextKey,
      hasNext: result.hasNext,
    );
  }

  @override
  Future<PageResultEntity<AlertEntity, int>> getAnnouncements({
    int? page,
    AlertType? type,
  }) async {
    final PageResult<Alert, int> result = await _remoteDataSource
        .fetchAnnouncements(page, type: type);

    final convertedItems = result.items.map((e) => e.toEntity()).toList();

    return PageResultEntity<AlertEntity, int>(
      items: convertedItems,
      nextKey: result.nextKey,
      hasNext: result.hasNext,
    );
  }

  @override
  Future<bool> deleteAnnouncement(int id) {
    return _remoteDataSource.deleteAnnouncement(id);
  }
}
