import 'package:flutter/material.dart';
import 'package:team_project_front/calendar/component/custom_text_input.dart';
import 'package:team_project_front/common/component/navigation_button.dart';

class PlanAdd extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final VoidCallback onPressed;

  const PlanAdd({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: SizedBox(
        height: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextInput(
              label: '제목',
              hintText: '제목을 입력해주세요.',
              controller: titleController,
            ),
            SizedBox(height: 12),
            CustomTextInput(
              label: '내용',
              hintText: '내용을 입력해주세요.',
              controller: contentController,
              maxLines: 7,
            ),
            SizedBox(height: 32),
            NavigationButton(
              text: '추가',
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
