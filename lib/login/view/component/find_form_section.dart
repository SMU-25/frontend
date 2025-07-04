import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:team_project_front/common/component/custom_input.dart';

class FindFormSection extends StatefulWidget {
  const FindFormSection({
    super.key,
    required this.formKey,
    required this.emailController,
    this.isPassword,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final bool? isPassword;
  @override
  State<FindFormSection> createState() => _FindIdFormSectionState();
}

class _FindIdFormSectionState extends State<FindFormSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 폼 영역
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: widget.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    '이메일을 입력해주세요',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 90,
                    child: Stack(
                      children: [
                        CustomTextFormField(
                          controller: widget.emailController,
                          hintText: '이메일 입력',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '이메일을 입력해주세요';
                            } else if (!EmailValidator.validate(value) ||
                                RegExp(r'[ㄱ-ㅎㅏ-ㅣ가-힣]').hasMatch(value)) {
                              return '이메일을 제대로 입력해주세요';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 안내 메시지 영역
          const Divider(height: 1, thickness: 1),
          Container(
            height: 100,
            decoration: const BoxDecoration(
              color: Color.fromARGB(125, 253, 246, 246),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: Icon(Icons.info_outline, size: 30),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: Text(
                    widget.isPassword == true
                        ? '기존에 가입하신 이메일을 입력하시면,\n새 비밀번호를 메일로 알려드립니다.'
                        : '기존에 가입하신 이메일을 입력하시면,\n아이디를 메일로 알려드립니다.',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
        ],
      ),
    );
  }
}
