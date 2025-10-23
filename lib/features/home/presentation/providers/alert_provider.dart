import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_project_front/features/home/data/datasources/alert_data_source.dart';
import 'package:team_project_front/features/home/data/repositories/alert_repository_impl.dart';
import 'package:team_project_front/features/home/domain/entities/notification_entiry.dart';
import 'package:team_project_front/features/home/domain/repositories/alert_repository.dart';
import 'package:team_project_front/features/home/domain/usecase/alert_usecase.dart';

// 의존성 주입
final alertDataSourceProvider = Provider<AlertDataSource>((ref) {
  return AlertDataSource();
});

final alertRepositoryProvider = Provider<AlertRepository>((ref) {
  final dataSource = ref.watch(alertDataSourceProvider);
  return AlertRepositoryImpl(dataSource);
});

final alertUsecaseProvider = Provider<AlertUsecase>((ref) {
  final repo = ref.watch(alertRepositoryProvider);
  return AlertUsecase(repo);
});

final alertNotifierProvider =
    AsyncNotifierProvider<AlertNotifier, List<NotificationItemEntity>>(
      AlertNotifier.new,
    );

class AlertNotifier extends AsyncNotifier<List<NotificationItemEntity>> {
  late final AlertUsecase _usecase;

  // 페이지네이션 상태 저장용
  int? _nextCursor;
  bool _hasNext = true;
  bool _isLoadingMore = false;

  @override
  Future<List<NotificationItemEntity>> build() async {
    _usecase = ref.read(alertUsecaseProvider);
    return _fetchInitial();
  }

  // 첫 페이지 불러오기
  /// - build()에서 return하면 자동으로 AsyncData(...)로 감싸서 state에 반영된다.
  Future<List<NotificationItemEntity>> _fetchInitial() async {
    state = const AsyncLoading();
    try {
      final res = await _usecase.getNotifications(cursor: null);
      _nextCursor = res.nextKey;
      _hasNext = res.hasNext;
      return res.items;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  // 새로고침 (1페이지부터 다시)
  Future<void> refresh() async {
    state = const AsyncLoading();
    final res = await _usecase.getNotifications(cursor: null);
    _nextCursor = res.nextKey;
    _hasNext = res.hasNext;
    state = AsyncData(res.items);
  }

  // 다음 페이지 로드 (무한 스크롤 시 호출)
  Future<void> loadMore() async {
    // 더 이상 페이지 없거나 로딩 중이면 무시
    if (!_hasNext || _isLoadingMore) return;

    _isLoadingMore = true;

    // 기존 데이터 유지
    final previous = state.value ?? [];

    try {
      final res = await _usecase.getNotifications(cursor: _nextCursor);
      _nextCursor = res.nextKey;
      _hasNext = res.hasNext;

      // 기존 리스트에 새 항목 이어붙이기
      final combined = [...previous, ...res.items];
      state = AsyncData(combined);
    } catch (e, st) {
      // 기존 데이터 유지 + 에러 표시
      state = AsyncError(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }
}
