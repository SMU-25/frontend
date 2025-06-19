import 'package:flutter/material.dart';

class LoginTextButton extends StatelessWidget {
  const LoginTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(foregroundColor: Colors.grey),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
