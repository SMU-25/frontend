import 'package:flutter/material.dart';
import 'package:team_project_front/calendar/component/calendar.dart';
import 'package:team_project_front/calendar/component/plan_banner.dart';
import 'package:team_project_front/calendar/component/plan_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime? selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

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
      body: Column(
        children: [
          Calendar(
            focusedDay: DateTime.now(),
            selectedDayPredicate: selectedDayPredicate,
            onDaySelected: onDaySelected,
          ),
          SizedBox(height: 16),
          PlanBanner(
            selectedDay: selectedDay!,
            taskCount: 0,
          ),
          Expanded(
            child: ListView(
              children: [
                PlanCard(
                  title: 'Voghair 응암역 2호점',
                  content: '10시 ~ 10:30, 서울특별시 은평구 은평로 41...',
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
    });
  }

  bool selectedDayPredicate(DateTime date) {
    if(selectedDay == null) {
      return false;
    }

    return date.isAtSameMomentAs(selectedDay!);
  }
}