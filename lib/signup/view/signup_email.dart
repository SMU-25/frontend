import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/signup/component/small_check.dart';
import 'package:team_project_front/signup/component/input_with_textbutton.dart';
import 'package:team_project_front/signup/view/signup_password.dart';

class SignupEmailScreen extends StatefulWidget {
  const SignupEmailScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _SignupEmailScreenState();
  }
}

class _SignupEmailScreenState extends State<SignupEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // 실시간 검증을 위해 getter function 사용
  bool get isEmail =>
      EmailValidator.validate(_emailController.text) &&
      !RegExp(r'[ㄱ-ㅎㅏ-ㅣ가-힣]').hasMatch(_emailController.text);

  // api 연결 후 로직 수정
  bool isVerify = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  '이메일을 입력해주세요',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 130,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 20,
                        left: 0,
                        right: 0,
                        child: InputWithTextButton(
                          controller: _emailController,
                          hintText: '이메일 입력',
                          buttonText: '인증하기',
                          onPressed: () {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '이메일을 입력해주세요';
                            } else if (!EmailValidator.validate(value) ||
                                RegExp(r'[ㄱ-ㅎㅏ-ㅣ가-힣]').hasMatch(value)) {
                              return '이메일을 제대로 입력해주세요';
                            }
                            return null;
                          },
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 23,
                            horizontal: 20,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Row(
                          children: [
                            SmallCheck(text: '인증 완료', checked: isVerify),
                            const SizedBox(width: 10),
                            SmallCheck(text: '이메일', checked: isEmail),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: NavigationButton(
            text: '다음',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            SignupPasswordScreen(email: _emailController.text),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
