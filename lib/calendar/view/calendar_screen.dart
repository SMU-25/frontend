import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:team_project_front/common/const/colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    final defaultBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      border: Border.all(
        color: Colors.grey[200]!,
        width: 1,
      )
    );

    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );

    return Scaffold(
      body: TableCalendar(
        locale: 'ko_KR',
        focusedDay: DateTime.now(),
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
            border: Border.all(
              color: MAIN_COLOR,
            )
          ),
          todayDecoration: defaultBoxDecoration.copyWith(
            color: MAIN_COLOR,
          ),
          outsideDecoration: defaultBoxDecoration.copyWith(
            border: Border.all(
              color: Colors.transparent,
            )
          ),
          defaultTextStyle: defaultTextStyle,
          weekendTextStyle: defaultTextStyle,
          selectedTextStyle: defaultTextStyle.copyWith(
            color: MAIN_COLOR,
          ),
        ),
        selectedDayPredicate: (DateTime date) {
          if (selectedDay == null) return false;

          return date.isAtSameMomentAs(selectedDay!);
        },
        onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
          setState(() {
            this.selectedDay = selectedDay;
          });
        },
      ),
    );
  }
}