import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class CustomNotificationToggleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const CustomNotificationToggleTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          trailing: CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: MAIN_COLOR,
          ),
        ),
        SizedBox(height: 28),
      ],
    );
  }
}
