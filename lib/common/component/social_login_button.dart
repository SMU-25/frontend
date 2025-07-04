import 'package:flutter/material.dart';

Color getSocialColor(String type) {
  switch (type) {
    case 'naver':
      return const Color(0xFF00BF18);
    case 'kakao':
      return const Color(0xFFFFE812);
    case 'google':
      return Colors.white;
    default:
      return Colors.grey;
  }
}

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.src,
    required this.type,
    required this.onPressed,
  });
  final String src;
  final String type;

  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: getSocialColor(type),
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
      child: Image.asset(src, height: 30, width: 30),
    );
  }
}
