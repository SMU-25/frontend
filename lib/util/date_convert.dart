String dateConvert(DateTime input) {
  DateTime now = DateTime.now();
  final utcFromLocal = now.toUtc();

  final krTime = input.toLocal();

  final diffMin = utcFromLocal.difference(input).inMinutes;
  final diffHour = utcFromLocal.difference(input).inHours;
  final diffDay = utcFromLocal.difference(input).inDays;

  if (diffMin < 60) {
    return '$diffMin분전';
  } else if (diffMin > 59 && diffMin < 1440) {
    return '$diffHour시간전';
  } else if (diffMin > 1439 && diffMin < 10080) {
    return '$diffDay일전';
  } else if (diffMin > 10079 && (utcFromLocal.year == input.year)) {
    return '${krTime.month}월 ${krTime.day}일';
  } else {
    return '${krTime.year}년 ${krTime.month}월 ${krTime.day}일';
  }
}
