import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.text,
    required this.size,
    required this.value,
    required this.onChanged,
    this.showArrow = false,
  });

  final String text;
  final double size;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool showArrow;

  @override
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: 1.5,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                // Checkbox 기본 마진 없애기
                visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
                fillColor: WidgetStateProperty.resolveWith<Color>((
                  Set<WidgetState> states,
                ) {
                  return states.contains(WidgetState.selected)
                      ? MAIN_COLOR
                      : Colors.grey;
                }),
              ),
            ),
            SizedBox(width: 20),
            Text(text, style: TextStyle(fontSize: size)),
          ],
        ),
        showArrow
            ? Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey)
            : SizedBox(),
      ],
    );
  }
}
