import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/login/view/component/find_form_section.dart';

class FindPasswordScreen extends StatefulWidget {
  const FindPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return FindPasswordScreenState();
  }
}

class FindPasswordScreenState extends State<FindPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool get isEmail =>
      EmailValidator.validate(_emailController.text) &&
      !RegExp(r'[ㄱ-ㅎㅏ-ㅣ가-힣]').hasMatch(_emailController.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 재설정', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FindFormSection(
        formKey: _formKey,
        emailController: _emailController,
        isPassword: true,
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: NavigationButton(
            text: '전송',
            onPressed: () {
              // 비밀번호 재설정 API 연결 예정
              if (_formKey.currentState!.validate()) {
                print('hello');
              }
            },
          ),
        ),
      ),
    );
  }
}
