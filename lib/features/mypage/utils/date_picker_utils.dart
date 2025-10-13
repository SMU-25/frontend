import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showYearPicker({
  required BuildContext context,
  required void Function(String year) onSelected,
  String? initialYear,
}) async {
  final currentYear = DateTime.now().year;
  final years = List.generate(100, (index) => (currentYear - index).toString());

  final int initialIndex = initialYear != null ? years.indexOf(initialYear) : 0;
  onSelected(years[initialIndex]);

  await showCupertinoModalPopup(
    context: context,
    builder: (_) => Container(
      height: 250,
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                initialItem: initialYear != null
                    ? years.indexOf(initialYear)
                    : 0,
              ),
              itemExtent: 40,
              onSelectedItemChanged: (index) {
                onSelected(years[index]);
              },
              children: years.map((y) => Center(child: Text('$y년'))).toList(),
            ),
          ),
          CupertinoButton(
            child: Text('확인'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    ),
  );
}

Future<void> showMonthPicker({
  required BuildContext context,
  required void Function(String month) onSelected,
  String? initialMonth,
}) async {
  final months = List.generate(12, (i) => (i + 1).toString().padLeft(2, '0'));

  final int initialIndex = initialMonth != null ? months.indexOf(initialMonth) : 0;
  onSelected(months[initialIndex]);

  await showCupertinoModalPopup(
    context: context,
    builder: (_) => Container(
      height: 250,
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                initialItem: initialMonth != null
                    ? months.indexOf(initialMonth)
                    : 0,
              ),
              itemExtent: 40,
              onSelectedItemChanged: (index) {
                onSelected(months[index]);
              },
              children: months.map((m) => Center(child: Text('$m월'))).toList(),
            ),
          ),
          CupertinoButton(
            child: Text('확인'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    ),
  );
}

Future<void> showDayPicker({
  required BuildContext context,
  required void Function(String day) onSelected,
  String? initialDay,
}) async {
  final days = List.generate(31, (i) => (i + 1).toString().padLeft(2, '0'));

  final int initialIndex = initialDay != null ? days.indexOf(initialDay) : 0;
  onSelected(days[initialIndex]);

  await showCupertinoModalPopup(
    context: context,
    builder: (_) => Container(
      height: 250,
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                initialItem: initialDay != null
                    ? days.indexOf(initialDay)
                    : 0,
              ),
              itemExtent: 40,
              onSelectedItemChanged: (index) {
                onSelected(days[index]);
              },
              children: days.map((d) => Center(child: Text('$d일'))).toList(),
            ),
          ),
          CupertinoButton(
            child: Text('확인'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    ),
  );
}