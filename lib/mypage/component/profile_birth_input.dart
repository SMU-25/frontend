import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/mypage/utils/date_picker_utils.dart';

class ProfileBirthInput extends StatelessWidget {
  final String? yearText;
  final String? monthText;
  final String? dayText;
  final Function(String) onYearSelected;
  final Function(String) onMonthSelected;
  final Function(String) onDaySelected;

  const ProfileBirthInput({
    super.key,
    required this.yearText,
    required this.monthText,
    required this.dayText,
    required this.onYearSelected,
    required this.onMonthSelected,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '생년월일',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                context: context,
                text: yearText,
                hintText: '0000',
                onTap: () => showYearPicker(
                  context: context,
                  initialYear: yearText,
                  onSelected: onYearSelected,
                ),
              ),
            ),
            SizedBox(width: 6),
            Text('년'),
            SizedBox(width: 10),
            Expanded(
              child: _buildDateField(
                context: context,
                text: monthText,
                hintText: '00',
                onTap: () => showMonthPicker(
                  context: context,
                  initialMonth: monthText,
                  onSelected: onMonthSelected,
                ),
              ),
            ),
            SizedBox(width: 6),
            Text('월'),
            SizedBox(width: 10),
            Expanded(
              child: _buildDateField(
                context: context,
                text: dayText,
                hintText: '00',
                onTap: () => showDayPicker(
                  context: context,
                  initialDay: dayText,
                  onSelected: onDaySelected,
                ),
              ),
            ),
            SizedBox(width: 6),
            Text('일'),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required String? text,
    required String hintText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          textAlign: TextAlign.center,
          readOnly: true,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: INPUT_BORDER_COLOR),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: ICON_GREY_COLOR, width: 1.5),
            ),
          ),
          controller: TextEditingController(text: text),
        ),
      ),
    );
  }
}
