import 'package:flutter/material.dart';
import 'package:team_project_front/features/home/data/models/page_result.dart';

class InfiniteList<T, K> extends StatefulWidget {
  const InfiniteList({
    super.key,
    required this.loader,
    required this.itemBuilder,
    this.separator,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.preloadOffset = 200,
    this.enableRefresh = true,
    this.bottomLoadingBuilder,
    this.errorBuilder,
    this.itemKey,
    this.onDismiss,
    this.dismissDirection = DismissDirection.endToStart,
    this.dismissBackgroundBuilder,
  });

  final PageLoader<T, K> loader;
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget? separator;
  final EdgeInsetsGeometry padding;
  final double preloadOffset;
  final bool enableRefresh;
  final Widget Function()? bottomLoadingBuilder;
  final Widget Function(String msg, VoidCallback retry)? errorBuilder;
  final Key Function(T item)? itemKey;
  final Future<bool> Function(T item)? onDismiss;
  final DismissDirection dismissDirection;
  final Widget Function(BuildContext, DismissDirection)?
  dismissBackgroundBuilder;

  @override
  State<InfiniteList<T, K>> createState() => _InfiniteListState<T, K>();
}

class _InfiniteListState<T, K> extends State<InfiniteList<T, K>> {
  final _items = <T>[];
  final _scroll = ScrollController();
  bool _isLoading = false;
  bool _hasNext = true;
  K? _nextKey;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetch(reset: true);
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoading || !_hasNext) return;
    final pos = _scroll.position;
    if (pos.pixels >= pos.maxScrollExtent - widget.preloadOffset) {
      _fetch();
    }
  }

  Future<void> _fetch({bool reset = false}) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      if (reset) {
        _error = null;
        _hasNext = true;
        _nextKey = null;
      }
    });
    try {
      final r = await widget.loader(_nextKey);
      if (!mounted) return;
      setState(() {
        if (reset) _items.clear();
        _items.addAll(r.items);
        _nextKey = r.nextKey;
        _hasNext = r.hasNext;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _refresh() => _fetch(reset: true);

  @override
  @override
  Widget build(BuildContext context) {
    // 에러 + 데이터 없음
    if (_items.isEmpty && _error != null && !_isLoading) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(_error!, () => _fetch(reset: true));
      }
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => _fetch(reset: true),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    final list = ListView.separated(
      controller: _scroll,
      padding: widget.padding,
      itemCount: _items.length + 1, // 바닥 로딩/끝 셀
      separatorBuilder: (_, __) => widget.separator ?? const Divider(height: 1),
      itemBuilder: (context, index) {
        // 실제 아이템 영역
        if (index < _items.length) {
          final item = _items[index];
          final tile = widget.itemBuilder(context, item);

          // 스와이프 삭제 미지원이면 그대로 반환
          if (widget.onDismiss == null || widget.itemKey == null) {
            return tile;
          }

          // 스와이프 삭제 지원
          return Dismissible(
            key: widget.itemKey!(item),
            direction: widget.dismissDirection,
            background:
                widget.dismissBackgroundBuilder?.call(
                  context,
                  widget.dismissDirection,
                ) ??
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: Colors.redAccent.withValues(alpha: 0.15),
                  child: const Icon(Icons.delete, color: Colors.redAccent),
                ),
            confirmDismiss: (dir) async {
              final ok = await widget.onDismiss!(item);
              if (ok && mounted) {
                setState(() {
                  _items.remove(item);
                });
              }
              return ok;
            },
            child: tile,
          );
        }

        // 바닥 로딩/끝 표시 영역
        if (_isLoading) {
          return widget.bottomLoadingBuilder?.call() ??
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
        }
        return const SizedBox.shrink();
      },
    );

    if (!widget.enableRefresh) return list;
    return RefreshIndicator(onRefresh: _refresh, child: list);
  }
}
