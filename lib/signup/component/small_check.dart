import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class SmallCheck extends StatelessWidget {
  const SmallCheck({super.key, required this.text, required this.checked});
  final String text;
  final bool checked;
  @override
  Widget build(BuildContext context) {
    final checkerColor = checked ? MAIN_COLOR : Colors.grey;
    return Row(
      children: [
        Icon(Icons.check, size: 20, color: checkerColor),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: checkerColor)),
      ],
    );
  }
}
