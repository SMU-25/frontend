import 'package:flutter/material.dart';
import 'package:team_project_front/core/const/colors.dart';
import 'package:team_project_front/core/network/dio_client.dart';
import 'package:team_project_front/features/home/component/inifinite_list.dart';
import 'package:team_project_front/features/home/model/notification.dart';
import 'package:team_project_front/features/home/model/notification_response.dart';
import 'package:team_project_front/features/home/model/alert.dart';
import 'package:team_project_front/features/home/model/page_result.dart';
import 'package:team_project_front/features/home/model/paged_alert_response.dart';
import 'package:team_project_front/features/homecam/util/format_relative_time.dart';

Future<PageResult<NotificationItem, int>> notificationsLoader(
  int? cursor,
) async {
  final dio = buildAuthedDio();

  final res = await dio.get(
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

String _typeToQuery(AlertType t) => t.name.toLowerCase();

Future<bool> deleteAnnouncement(int id) async {
  final dio = buildAuthedDio();

  final res = await dio.delete('/announcements/$id');
  return res.statusCode == 200;
}

Future<PageResult<Alert, int>> announcementsLoader(
  int? page, {
  AlertType? type,
}) async {
  final dio = buildAuthedDio();

  final currentPage = page ?? 0;

  final res = await dio.get(
    '/announcements',
    queryParameters: {
      if (type != null) 'type': _typeToQuery(type),
      'page': currentPage,
      'size': 20,
    },
  );
  if (res.statusCode != 200) {
    throw Exception('공지 조회 실패 (HTTP ${res.statusCode})');
  }
  final pr = PagedAlertResponse.fromJson(
    res.data['result'] as Map<String, dynamic>,
  );
  final nextPage = currentPage + 1;
  final hasNext = !pr.last && nextPage < pr.totalPages;

  return PageResult(
    items: pr.content,
    nextKey: hasNext ? nextPage : null,
    hasNext: hasNext,
  );
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.item});
  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];
    if (item.fever != null) {
      chips.add(_Chip(text: '체온 ${item.fever!.toStringAsFixed(1)}℃'));
    }
    if (item.temperature != null) {
      chips.add(_Chip(text: '방온도 ${item.temperature!.toStringAsFixed(1)}℃'));
    }
    if (item.humidity != null) {
      chips.add(_Chip(text: '습도 ${item.humidity!.toStringAsFixed(1)}%'));
    }

    return ListTile(
      minVerticalPadding: 12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: Icon(
        Icons.favorite,
        color: item.read ? Colors.grey : MAIN_COLOR,
      ),
      title: Text(
        item.message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16,
          fontWeight: item.read ? FontWeight.normal : FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (chips.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(spacing: 6, runSpacing: -6, children: chips),
          ],
          const SizedBox(height: 10),
          Text(
            '${item.childName} · ${formatRelativeTime(item.createdAt)}',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class AnnouncementTile extends StatelessWidget {
  const AnnouncementTile({super.key, required this.alert});
  final Alert alert;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3.4),
      leading: alert.pinned
          ? const Icon(Icons.campaign, color: MAIN_COLOR)
          : const Icon(Icons.event_available, color: MAIN_COLOR),
      title: Text(
        alert.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(alert.content, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Text(
            formatRelativeTime(alert.createdAt),
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final bg = text.contains('체온')
        ? Colors.redAccent
        : text.contains('습도')
        ? Colors.blueAccent
        : Colors.orangeAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.grey.shade300),
        color: bg.withValues(alpha: 0.08),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: bg, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class AlertScreen extends StatelessWidget {
  const AlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '알람',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.transparent,
              child: TabBar(
                indicator: BoxDecoration(
                  color: MAIN_COLOR.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.black,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: '케어'),
                  Tab(text: '공지/이벤트'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  InfiniteList<NotificationItem, int>(
                    loader: notificationsLoader,
                    itemBuilder: (_, n) => NotificationTile(item: n),
                  ),
                  InfiniteList<Alert, int>(
                    loader: (page) => announcementsLoader(page, type: null),
                    itemBuilder: (_, a) => AnnouncementTile(alert: a),
                    itemKey: (a) => ValueKey('alert_${a.id}'),
                    onDismiss: (a) async {
                      final ok = await deleteAnnouncement(a.id);
                      if (!ok) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('삭제 실패')));
                      } else {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('삭제 성공!')));
                      }
                      return ok;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
