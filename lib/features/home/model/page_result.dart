class PageResult<T, K> {
  final List<T> items;
  final K? nextKey; // 다음 페이지 키(커서/페이지번호 등)
  final bool hasNext;
  const PageResult({
    required this.items,
    required this.nextKey,
    required this.hasNext,
  });
}

typedef PageLoader<T, K> = Future<PageResult<T, K>> Function(K? key);
