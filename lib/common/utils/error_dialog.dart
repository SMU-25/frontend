import 'package:flutter/material.dart';

void showErrorDialog({required BuildContext context, required String message}) {
  showDialog(
    context: context,
    builder:
        (ctx) => AlertDialog(
          title: Text('오류'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('확인'),
            ),
          ],
        ),
  );
}
