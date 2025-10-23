import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_project_front/core/const/colors.dart';
import 'package:team_project_front/features/home/presentation/providers/alert_provider.dart';
import 'package:team_project_front/features/home/presentation/providers/announcement_provider.dart';
import 'package:team_project_front/features/home/presentation/widgets/alert/notification_tile.dart';
import 'package:team_project_front/features/home/presentation/widgets/alert/announcement_tile.dart';

class AlertScreen extends ConsumerWidget {
  const AlertScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsState = ref.watch(alertNotifierProvider);
    final notifier = ref.read(alertNotifierProvider.notifier);
    final announcementState = ref.watch(announcementNotifierProvider);
    final announcementNotifier = ref.read(
      announcementNotifierProvider.notifier,
    );

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
                  alertsState.when(
                    data: (items) => NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 100) {
                          notifier.loadMore();
                        }
                        return false;
                      },
                      child: RefreshIndicator(
                        onRefresh: () => notifier.refresh(),
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (_, i) =>
                              NotificationTile(item: items[i]),
                        ),
                      ),
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, st) {
                      debugPrint('에러: $e\n$st');
                      return const Center(child: Text('에러가 발생했어요 🥲'));
                    },
                  ),
                  announcementState.when(
                    data: (items) => RefreshIndicator(
                      onRefresh: () => announcementNotifier.refresh(),
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (_, i) {
                          final alert = items[i];
                          return Dismissible(
                            key: ValueKey('alert_${alert.id}'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.redAccent.withValues(alpha: 0.15),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                            ),
                            confirmDismiss: (_) async {
                              final ok = await announcementNotifier
                                  .removeAnnouncementById(alert.id);
                              if (!ok) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('삭제 실패')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('삭제 성공!')),
                                );
                              }
                              return ok;
                            },
                            onDismissed: (_) async {
                              await announcementNotifier.removeAnnouncementById(
                                alert.id,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('삭제 완료!')),
                              );
                            },
                            child: AnnouncementTile(alert: alert),
                          );
                        },
                      ),
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, st) => Center(child: Text('공지 불러오기 실패: $e')),
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
