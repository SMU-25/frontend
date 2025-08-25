import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/calendar/component/calendar.dart';
import 'package:team_project_front/calendar/component/plan_add.dart';
import 'package:team_project_front/calendar/component/plan_banner.dart';
import 'package:team_project_front/calendar/component/plan_card.dart';
import 'package:team_project_front/calendar/model/plan.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/common/utils/secure_storage_service.dart';

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

  DateTime focusedDay = DateTime.now();

  Map<DateTime, List<Plan>> plans = {};

  bool isLoading = true;
  String? accessToken;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    final token = await SecureStorageService.getAccessToken();

    if (token == null) {
      print('AccessToken 없음. 로그인 필요');
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      accessToken = 'Bearer $token';
    });

    await loadPlans();
  }

  Future<void> loadPlans() async {
    if (accessToken == null) return;

    final dio = Dio();
    try {
      final response = await dio.get(
        'https://momfy.kr/api/calendars/my',
        options: Options(headers: {'Authorization': accessToken}),
      );

      if (response.statusCode == 200 && response.data['isSuccess']) {
        final List<dynamic> jsonList = response.data['result'];

        final Map<DateTime, List<Plan>> tempPlans = {};

        for (var json in jsonList) {
          final plan = Plan.fromMap(json);
          final scheduleDate = DateTime.utc(plan.date.year, plan.date.month, plan.date.day);

          if (!tempPlans.containsKey(scheduleDate)) {
            tempPlans[scheduleDate] = [];
          }
          tempPlans[scheduleDate]!.add(plan);
        }

        setState(() {
          plans = tempPlans;
          isLoading = false;
        });
      }
    } catch (e) {
      print('일정 조회 실패: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

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
            focusedDay: focusedDay,
            selectedDayPredicate: selectedDayPredicate,
            onDaySelected: onDaySelected,
            eventLoader: (day) {
              final normalizedDay = DateTime.utc(day.year, day.month, day.day);
              return plans[normalizedDay] ?? [];
            },
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
                  key: ValueKey(planModel.calendarId),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: HIGH_FEVER_COLOR,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => {
                    setState(() {
                      plans[selectedDay]!.removeAt(index);
                    }),

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("삭제되었습니다.")),
                    )
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
                            existingId: planModel.calendarId,
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

  void onDaySelected(DateTime selectedDay, DateTime newFocusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      focusedDay = newFocusedDay;
    });
  }

  bool selectedDayPredicate(DateTime date) {
    if(selectedDay == null) {
      return false;
    }

    return date.isAtSameMomentAs(selectedDay!);
  }
}