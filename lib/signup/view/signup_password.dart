import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/custom_input.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/signup/component/small_check.dart';
import 'package:team_project_front/signup/view/signup_user_info.dart';

class SignupPasswordScreen extends StatefulWidget {
  const SignupPasswordScreen({super.key, required this.email});
  final String email;
  @override
  State<StatefulWidget> createState() {
    return _SignupPasswordState();
  }
}

class _SignupPasswordState extends State<SignupPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isEnglish = false;
  bool isNumber = false;
  bool isSpecial = false;
  bool isValidLength = false;
  bool isMatch = false;

  void _validatePassword(String value) {
    setState(() {
      isEnglish = value.contains(RegExp(r'[a-zA-Z]'));
      isNumber = value.contains(RegExp(r'[0-9]'));
      isSpecial = value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
      isValidLength = value.length >= 8 && value.length <= 16;
    });
  }

  void _validateMatch() {
    setState(() {
      isMatch = _passwordController.text == _confirmPasswordController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      _validatePassword(_passwordController.text);
      _validateMatch();
    });
    _confirmPasswordController.addListener(() {
      _validateMatch();
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
                const Text(
                  '비밀번호를 입력해주세요',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 110,
                  child: Stack(
                    children: [
                      CustomTextFormField(
                        controller: _passwordController,
                        hintText: '비밀번호 입력',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력해주세요';
                          } else if (!RegExp(
                            r'^[a-zA-Z0-9!@#\$%^&*(),.?":{}|<>]+$',
                          ).hasMatch(value)) {
                            return '사용할 수 없는 문자가 포함되어 있습니다';
                          } else if (!isEnglish || !isNumber || !isSpecial) {
                            return '영문, 숫자, 특수문자를 모두 포함해주세요';
                          } else if (!isValidLength) {
                            return '8자 이상 16자 이하로 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 60),
                            child: Row(
                              children: [
                                SmallCheck(text: '영문', checked: isEnglish),
                                const SizedBox(width: 10),
                                SmallCheck(text: '숫자', checked: isNumber),
                                const SizedBox(width: 10),
                                SmallCheck(text: '특수문자', checked: isSpecial),
                                const SizedBox(width: 10),
                                SmallCheck(
                                  text: '8~16자',
                                  checked: isValidLength,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 110,
                  child: Stack(
                    children: [
                      CustomTextFormField(
                        controller: _confirmPasswordController,
                        hintText: '비밀번호 확인',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 다시 입력해주세요';
                          } else if (value != _passwordController.text) {
                            return '비밀번호가 일치하지 않습니다';
                          }
                          return null;
                        },
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 60),
                            child: SmallCheck(text: '일치', checked: isMatch),
                          ),
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
                        (_) => SignupUserInfoScreen(
                          email: widget.email,
                          password: _confirmPasswordController.text,
                        ),
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
