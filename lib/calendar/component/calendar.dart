import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:team_project_front/common/const/colors.dart';

class Calendar extends StatelessWidget {
  final DateTime focusedDay;
  final bool Function(DateTime)? selectedDayPredicate;
  final void Function(DateTime selectedDay, DateTime focusedDay)? onDaySelected;
  final List<Object> Function(DateTime day)? eventLoader;

  const Calendar({
    super.key,
    required this.focusedDay,
    required this.selectedDayPredicate,
    required this.onDaySelected,
    this.eventLoader,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      border: Border.all(
        color: Colors.grey[200]!,
        width: 1,
      ),
    );

    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );

    return TableCalendar(
      locale: 'ko_KR',
      focusedDay: focusedDay,
      firstDay: DateTime(2025),
      lastDay: DateTime(2100),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        defaultDecoration: defaultBoxDecoration,
        weekendDecoration: defaultBoxDecoration,
        selectedDecoration: defaultBoxDecoration.copyWith(
          border: Border.all(color: MAIN_COLOR),
        ),
        todayDecoration: defaultBoxDecoration.copyWith(
          color: MAIN_COLOR,
        ),
        outsideDecoration: defaultBoxDecoration.copyWith(
          border: Border.all(color: Colors.transparent),
        ),
        defaultTextStyle: defaultTextStyle,
        weekendTextStyle: defaultTextStyle,
        selectedTextStyle: defaultTextStyle.copyWith(
          color: MAIN_COLOR,
        ),
      ),
      selectedDayPredicate: selectedDayPredicate,
      onDaySelected: onDaySelected,
      eventLoader: eventLoader,
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if(events.isEmpty) return SizedBox();

          final limitedEvents = events.take(3).toList();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              limitedEvents.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 1),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MAIN_COLOR,
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
