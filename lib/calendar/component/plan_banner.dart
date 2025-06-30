import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class PlanBanner extends StatelessWidget {
  final DateTime selectedDay;
  final int taskCount;

  const PlanBanner({
    required this.selectedDay,
    required this.taskCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '$taskCount개',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
