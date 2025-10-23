String formatRelativeTime(DateTime? dt) {
  if (dt == null) return '시간 정보 없음';

  final diff = DateTime.now().difference(dt);

  if (diff.inSeconds < 60) {
    return '${diff.inSeconds}초 전';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes}분 전';
  } else if (diff.inHours < 24) {
    return '${diff.inHours}시간 전';
  } else {
    return '${diff.inDays}일 전';
  }
}
