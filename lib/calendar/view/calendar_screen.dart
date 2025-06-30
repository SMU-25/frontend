import 'package:flutter/material.dart';
import 'package:team_project_front/calendar/component/calendar.dart';
import 'package:team_project_front/calendar/component/plan_add.dart';
import 'package:team_project_front/calendar/component/plan_banner.dart';
import 'package:team_project_front/calendar/component/plan_card.dart';
import 'package:team_project_front/calendar/model/plan.dart';
import 'package:team_project_front/common/const/colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  DateTime? selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  Map<DateTime, List<Plan>> plans = {
    DateTime.utc(2025, 6, 30) : [
      Plan(
        id: 1,
        title: 'Voghair 응암역 2호점',
        content: '10시 ~ 10:30, 서울특별시 은평구 은평로 41...',
        date: DateTime.utc(2025, 6, 30),
        createdAt: DateTime.now().toUtc(),
      ),
      Plan(
        id: 2,
        title: '상명대학교',
        content: '졸프 회의 및 교수님 면담',
        date: DateTime.utc(2025, 6, 30),
        createdAt: DateTime.now().toUtc(),
      )
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,
        highlightElevation: 0,
        onPressed: () async {
          final resp = await showModalBottomSheet<Plan>(
            context: context,
            isScrollControlled: true,
            builder: (_) {
              return PlanAdd(
                titleController: titleController..clear(),
                contentController: contentController..clear(),
                selectedDay: selectedDay!,
              );
            },
          );

          if(resp == null) {
            return;
          }

          setState(() {
            plans = {
              ...plans,
              resp.date: [
                if(plans.containsKey(resp.date))
                  ...plans[resp.date]!,
                resp,
              ]
            };
          });
        },
        child: Icon(
          size: 40,
          Icons.add_circle,
          color: MAIN_COLOR,
        ),
      ),
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
          ),
          Expanded(
            child: ListView.builder(
              itemCount: plans.containsKey(selectedDay) ? plans[selectedDay]!.length : 0,
              itemBuilder: (BuildContext context, int index) {
                final selectedPlans = plans[selectedDay]!;
                final planModel = selectedPlans[index];

                return Dismissible(
                  key: ValueKey(planModel.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => {
                    setState(() {
                      plans[selectedDay]!.removeAt(index);
                    }),
                    // db에서 삭제하는 로직 구현 예정
                  },
                  child: PlanCard(
                    title: planModel.title,
                    content: planModel.content,
                    onEditPressed: () async {
                      titleController.text = planModel.title;
                      contentController.text = planModel.content;

                      final editedPlan = await showModalBottomSheet<Plan>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) {
                          return PlanAdd(
                            titleController: titleController..text = planModel.title,
                            contentController: contentController..text = planModel.content,
                            selectedDay: selectedDay!,
                            existingId: planModel.id,
                          );
                        },
                      );

                      if (editedPlan != null) {
                        setState(() {
                          final list = List<Plan>.from(plans[selectedDay]!);
                          list[index] = editedPlan;
                          plans[selectedDay!] = list;
                        });
                      }
                    },
                  ),
                );
              },
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