import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/calendar/component/custom_text_input.dart';
import 'package:team_project_front/calendar/model/plan.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/utils/secure_storage_service.dart';


class PlanAdd extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final DateTime selectedDay;
  final int? existingId;

  const PlanAdd({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.selectedDay,
    this.existingId,
  });

  @override
  State<PlanAdd> createState() => _PlanAddState();
}

class _PlanAddState extends State<PlanAdd> {
  final _formKey = GlobalKey<FormState>();
  bool isFormValid = false;

  void _validateForm() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (valid != isFormValid) {
      setState(() {
        isFormValid = valid;
      });
    }
  }

  void onPressed () async {
    final accessToken = await SecureStorageService.getAccessToken();

    if (accessToken == null) {
      print('AccessToken 없음!');
      return;
    }

    final requestBody = {
      "recordDate": DateTime.now().toIso8601String().substring(0, 10),
      "scheduleDate": widget.selectedDay.toIso8601String().substring(0, 10),
      "title": widget.titleController.text,
      "content": widget.contentController.text,
    };

    final dio = Dio();
    try {
      final response = await dio.post(
        '$base_URL/calendars',
        data: requestBody,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data['isSuccess'] == true) {
        final result = response.data['result'];

        final newPlan = Plan.fromMap({
          'calendarId': result['calendarId'],
          'recordDate': result['recordDate'],
          'scheduleDate': result['scheduleDate'],
          'title': result['title'],
          'content': result['content'],
        });

        Navigator.of(context).pop(newPlan);
      } else {
        print('일정 생성 실패: ${response.data['message']}');
        Navigator.of(context).pop(null);
      }
    } catch (e) {
      print('일정 생성 중 오류 발생: $e');
      Navigator.of(context).pop(null);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.titleController.addListener(_validateForm);
    widget.contentController.addListener(_validateForm);
  }

  @override
  void dispose() {
    widget.titleController.removeListener(_validateForm);
    widget.contentController.removeListener(_validateForm);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 25,
        right: 25,
        top: 25,
        bottom: MediaQuery.of(context).viewInsets.bottom + 25,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          onChanged: _validateForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextInput(
                label: '제목',
                hintText: '제목을 입력해주세요.',
                controller: widget.titleController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '제목은 필수 입력 항목입니다.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              CustomTextInput(
                label: '내용',
                hintText: '내용을 입력해주세요.',
                controller: widget.contentController,
                maxLines: 7,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '내용을 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 28),
              NavigationButton(
                text: '저장',
                onPressed: isFormValid ? onPressed : null,
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
