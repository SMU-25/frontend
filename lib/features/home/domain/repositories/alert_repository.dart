import 'package:team_project_front/features/home/domain/entities/alert_entity.dart';
import 'package:team_project_front/features/home/domain/entities/notification_entiry.dart';
import 'package:team_project_front/features/home/domain/entities/page_result_entity.dart';

abstract class AlertRepository {
  Future<PageResultEntity<NotificationItemEntity, int>> getNotifications({
    int? cursor,
  });

  Future<PageResultEntity<AlertEntity, int>> getAnnouncements({
    int? page,
    AlertType? type,
  });

  Future<bool> deleteAnnouncement(int id);
}
