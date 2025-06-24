import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/custom_input.dart';

class ProfileNameInput extends StatelessWidget {
  final TextEditingController controller;

  const ProfileNameInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이름 / 닉네임',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        CustomTextFormField(
          controller: controller,
          hintText: '이름 또는 애칭 입력(2-8자)',
          validator: (val) {
            if (val == null || val.isEmpty) {
              return '이름을 입력해주세요';
            }
            if (val.length < 2 || val.length > 8) {
              return '2~8자 이내로 입력해주세요';
            }
            if (!RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(val)) {
              return '한글 또는 영문만 입력 가능합니다';
            }
            return null;
          },
        ),
      ],
    );
  }
}
