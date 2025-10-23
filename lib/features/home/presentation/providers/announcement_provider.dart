import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_project_front/features/home/domain/entities/alert_entity.dart';
import 'package:team_project_front/features/home/domain/usecase/alert_usecase.dart';
import 'package:team_project_front/features/home/presentation/providers/alert_provider.dart'; // 기존 주입 재사용

final announcementNotifierProvider =
    AsyncNotifierProvider<AnnouncementNotifier, List<AlertEntity>>(
      AnnouncementNotifier.new,
    );

class AnnouncementNotifier extends AsyncNotifier<List<AlertEntity>> {
  late final AlertUsecase _usecase;

  int? _nextPage;
  bool _hasNext = true;
  bool _isLoadingMore = false;

  @override
  Future<List<AlertEntity>> build() async {
    _usecase = ref.read(alertUsecaseProvider);
    return _fetchInitial();
  }

  Future<List<AlertEntity>> _fetchInitial() async {
    state = const AsyncLoading();
    try {
      final res = await _usecase.getAnnouncements(page: 0);
      _nextPage = res.nextKey;
      _hasNext = res.hasNext;
      return res.items;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final res = await _usecase.getAnnouncements(page: 0);
    _nextPage = res.nextKey;
    _hasNext = res.hasNext;
    state = AsyncData(res.items);
  }

  Future<void> loadMore() async {
    if (!_hasNext || _isLoadingMore) return;
    _isLoadingMore = true;

    final previous = state.value ?? [];

    try {
      final res = await _usecase.getAnnouncements(page: _nextPage);
      _nextPage = res.nextKey;
      _hasNext = res.hasNext;
      state = AsyncData([...previous, ...res.items]);
    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<bool> removeAnnouncementById(int id) async {
    try {
      final success = await _usecase.deleteAnnouncement(id);
      if (!success) {
        return false;
      }
      final current = state.value;
      if (current == null) return false;
      final updated = current.where((a) => a.id != id).toList();
      state = AsyncData(updated);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}
