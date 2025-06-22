import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class CompleteDialog extends StatelessWidget {
  final Widget image;
  final String title;
  final String content;
  final String checkText;
  final VoidCallback onPressedCheck;

  const CompleteDialog({
    required this.image,
    required this.title,
    required this.content,
    required this.checkText,
    required this.onPressedCheck,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            image,
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MAIN_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 0,
                minimumSize: Size(100, 40),
              ).copyWith(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                splashFactory: NoSplash.splashFactory,
                animationDuration: Duration.zero,
                shadowColor: WidgetStateProperty.all(Colors.transparent),
              ),
              onPressed: onPressedCheck,
              child: Text(
                checkText,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
