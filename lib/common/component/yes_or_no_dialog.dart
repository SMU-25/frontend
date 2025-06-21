import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class YesOrNoDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onPressedYes;
  final String yesText;
  final String noText;


  const YesOrNoDialog({
    required this.title,
    required this.content,
    required this.onPressedYes,
    required this.yesText,
    required this.noText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: Colors.black26,
          width: 1.0,
        )
      ),
      title: Center(
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20.0,
          ),
        ),
      ),
      content: SizedBox(
        width: 280,
        child: Text(
          content,
          style: TextStyle(
            height: 1.9,
            fontSize: 14.0,
            color: Colors.black54,
            fontWeight: FontWeight.w500
          ),
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MAIN_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 0,
                minimumSize: Size(100, 40),
              ).copyWith(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                splashFactory: NoSplash.splashFactory,
                animationDuration: Duration.zero,
                shadowColor: WidgetStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onPressedYes();
              },
              child: Text(
                yesText,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MAIN_COLOR.withValues(alpha: 0.18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 0,
                minimumSize: Size(100, 40),
              ).copyWith(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                splashFactory: NoSplash.splashFactory,
                animationDuration: Duration.zero,
                shadowColor: WidgetStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                noText,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                  color: MAIN_COLOR,
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}