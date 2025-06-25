import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class PasswordInput extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmController;

  const PasswordInput({
    required this.passwordController,
    required this.confirmController,
    super.key,
  });

  bool get hasMinLength =>
    passwordController.text.length >= 8 && passwordController.text.length <= 16;
  bool get hasLetter => RegExp(r'[A-Za-z]').hasMatch(passwordController.text);
  bool get hasNumber => RegExp(r'[0-9]').hasMatch(passwordController.text);
  bool get hasSpecial => RegExp(r'[!@#%^&*(),.?":{}|<>]').hasMatch(passwordController.text);
  bool get isMatch =>
    passwordController.text.isNotEmpty &&
      confirmController.text.isNotEmpty &&
      passwordController.text == confirmController.text;

  OutlineInputBorder getBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: 1.5),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: '변경하시려면 새로 입력해주세요',
            hintStyle: TextStyle(color: INPUT_BORDER_COLOR),
            focusedBorder: getBorder(MAIN_COLOR),
            enabledBorder: getBorder(ICON_GREY_COLOR),
          ),
        ),
        SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            _buildCheckLabel('영문', hasLetter),
            _buildCheckLabel('숫자', hasNumber),
            _buildCheckLabel('특수문자', hasSpecial),
            _buildCheckLabel('8~16자리', hasMinLength),
          ],
        ),
        SizedBox(height: 16),

        TextFormField(
          controller: confirmController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: '비밀번호 확인',
            hintStyle: TextStyle(color: INPUT_BORDER_COLOR),
            focusedBorder: getBorder(MAIN_COLOR),
            enabledBorder: getBorder(ICON_GREY_COLOR),
          ),
        ),
        SizedBox(height: 8),

        _buildCheckLabel('비밀번호 일치', isMatch),
      ],
    );
  }

  Widget _buildCheckLabel(String label, bool valid) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check,
            size: 18, color: valid ? MAIN_COLOR : Colors.grey.shade400),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: valid ? MAIN_COLOR : Colors.grey.shade400,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}