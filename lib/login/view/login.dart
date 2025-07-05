import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/custom_input.dart';
import 'package:team_project_front/common/component/login_text_button.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/common/component/social_login_button.dart';
import 'package:team_project_front/home/view/home.dart';
import 'package:team_project_front/login/view/find_id.dart';
import 'package:team_project_front/login/view/find_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  double logoSize = 200;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isObscure = true;
  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (ctx) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'asset/img/logo/mom_fill_logo.png',
                    height: logoSize,
                    width: logoSize,
                  ),
                  CustomTextFormField(
                    controller: _idController,
                    hintText: '아이디를 입력하세요',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이메일 입력해주세요';
                      } else if (!EmailValidator.validate(value) ||
                          RegExp(r'[ㄱ-ㅎㅏ-ㅣ가-힣]').hasMatch(value)) {
                        return '올바른 형식을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    controller: _passwordController,
                    hintText: '비밀번호',
                    obscureText: _isObscure,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력해주세요';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  NavigationButton(text: '로그인', onPressed: _login),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoginTextButton(
                        text: '회원가입',
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                      ),
                      Text('|'),
                      LoginTextButton(
                        text: '아이디 찾기',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FindIdScreen(),
                            ),
                          );
                        },
                      ),
                      Text('|'),
                      LoginTextButton(
                        text: '비밀번호 재설정',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // 수정
                              builder: (context) => FindPasswordScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SocialLoginButton(
                        src: 'asset/img/login/kakao_icon.png',
                        type: 'kakao',
                        onPressed: () {},
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: SocialLoginButton(
                          src: 'asset/img/login/naver_icon.png',
                          type: 'naver',
                          onPressed: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: SocialLoginButton(
                          src: 'asset/img/login/google_icon.png',
                          type: 'google',
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text(
                    '소셜 아이디로 로그인',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
