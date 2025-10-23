import 'package:team_project_front/features/home/domain/entities/alert_entity.dart';
import 'package:team_project_front/features/home/domain/entities/notification_entiry.dart';
import 'package:team_project_front/features/home/domain/entities/page_result_entity.dart';
import 'package:team_project_front/features/home/domain/repositories/alert_repository.dart';

class AlertUsecase {
  final AlertRepository _repository;

  AlertUsecase(this._repository);

  Future<PageResultEntity<AlertEntity, int>> getAnnouncements({
    int? page,
    AlertType? type,
  }) async {
    return await _repository.getAnnouncements(page: page, type: type);
  }

  Future<PageResultEntity<NotificationItemEntity, int>> getNotifications({
    int? cursor,
  }) async {
    return await _repository.getNotifications(cursor: cursor);
  }

  Future<bool> deleteAnnouncement(int id) async {
    return await _repository.deleteAnnouncement(id);
  }
}
