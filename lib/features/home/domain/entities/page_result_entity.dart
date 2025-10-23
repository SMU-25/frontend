class PageResultEntity<T, K> {
  final List<T> items;
  final K? nextKey;
  final bool hasNext;

  const PageResultEntity({
    required this.items,
    required this.nextKey,
    required this.hasNext,
  });
}
