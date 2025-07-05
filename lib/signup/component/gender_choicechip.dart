import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/common/model/user.dart'; // Gender enum이 정의된 곳

class GenderChoiceChip extends StatelessWidget {
  final Gender gender;
  final Gender? selectedGender;
  final ValueChanged<Gender> onSelected;

  const GenderChoiceChip({
    super.key,
    required this.gender,
    required this.selectedGender,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = gender == selectedGender;
    final String label = gender == Gender.male ? '남자' : '여자';

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(gender),
      labelStyle: TextStyle(
        fontSize: 17,
        color: isSelected ? MAIN_COLOR : Colors.black,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: isSelected ? MAIN_COLOR : Colors.grey),
      ),
      padding: EdgeInsets.symmetric(horizontal: 55, vertical: 20),

      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      showCheckmark: false,
      backgroundColor: Colors.transparent,
      selectedColor: const Color(0xFFE8F7F6),
    );
  }
}
