import 'package:flutter/material.dart';
import 'package:team_project_front/calendar/component/custom_text_input.dart';
import 'package:team_project_front/calendar/model/plan.dart';
import 'package:team_project_front/common/component/navigation_button.dart';

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

  void onPressed () {
    // final plan = Plan(
    //   calendarId: widget.existingId ?? DateTime.now().millisecondsSinceEpoch,
    //   title: widget.titleController.text,
    //   content: widget.contentController.text,
    //   date: widget.selectedDay,
    //   recordDate: DateTime.now().toUtc(),
    // );

    // Navigator.of(context).pop(
    //   plan,
    // );
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
