import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_naver_login/interface/types/naver_login_result.dart';
import 'package:flutter_naver_login/interface/types/naver_login_status.dart';

import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:team_project_front/common/component/custom_input.dart';
import 'package:team_project_front/common/component/login_text_button.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/common/component/social_login_button.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/utils/error_dialog.dart';
import 'package:team_project_front/common/utils/secure_storage_service.dart';
import 'package:team_project_front/login/view/find_password.dart';
import 'package:dio/dio.dart';

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

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final dio = Dio();

        final res = await dio.post(
          '$base_URL/auth/login',
          data: {
            'email': _idController.text.trim(),
            'password': _passwordController.text,
          },
        );
        if (res.statusCode == 200) {
          final token = res.data['result']['accessToken'];
          await SecureStorageService.saveAccessToken(token);
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          if (!mounted) return;
          showErrorDialog(context: context, message: '로그인에 실패했습니다.');
        }
      } on DioException catch (err) {
        String message = '알 수 없는 오류가 발생했습니다.';
        if (err.response != null && err.response?.data != null) {
          message = err.response?.data['message'] ?? message;
        }
        if (!mounted) return;
        showErrorDialog(context: context, message: message);
      }
    }
  }

  Future<void> _socialLogin(String provider, String accessToken) async {
    try {
      final dio = Dio();

      final res = await dio.post(
        '$base_URL/auth/social-login',
        data: {'provider': provider, 'accessToken': accessToken},
      );
      if (res.statusCode == 200) {
        final token = res.data['result']['accessToken'];
        await SecureStorageService.saveAccessToken(token);

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        if (!mounted) return;
        showErrorDialog(context: context, message: '소셜 로그인에 실패했습니다.');
      }
    } on DioException catch (err) {
      String message = '알 수 없는 오류가 발생했습니다.';
      if (err.response != null && err.response?.data != null) {
        message = err.response?.data['message'] ?? message;
      }
      if (!mounted) return;
      showErrorDialog(context: context, message: message);
    }
  }

  void signInWithKakao() async {
    // 카카오톡이 설치되어 있으면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    OAuthToken token;
    if (await isKakaoTalkInstalled()) {
      try {
        token = await UserApi.instance.loginWithKakaoTalk();
        await _socialLogin('kakao', token.accessToken);
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          token = await UserApi.instance.loginWithKakaoAccount();
          await _socialLogin('kakao', token.accessToken);
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        token = await UserApi.instance.loginWithKakaoAccount();
        await _socialLogin('kakao', token.accessToken);
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  Future<void> signInWithNaver() async {
    try {
      // 1) 로그인 시도
      final NaverLoginResult res = await FlutterNaverLogin.logIn();
      if (res.status != NaverLoginStatus.loggedIn) {
        // 사용자가 창을 닫거나 취소한 경우가 포함될 수 있음
        return;
      }

      // 2) 액세스 토큰 가져오기
      // 패키지 버전에 따라 두 가지 중 하나가 유효함:
      // (A) 결과 객체에서 바로:
      String? accessToken = res.accessToken?.accessToken;

      // (B) 또는 현재 토큰 조회:
      accessToken ??=
          (await FlutterNaverLogin.getCurrentAccessToken()).accessToken;

      if (accessToken.isEmpty) {
        if (!mounted) return;
        showErrorDialog(context: context, message: '네이버 토큰을 가져오지 못했습니다.');
        return;
      }

      // 3) 우리 서버 소셜 로그인
      await _socialLogin('naver', accessToken);
    } on PlatformException catch (e) {
      // iOS 웹 세션 취소 등
      if (e.code == 'CANCELED') return;
      if (!mounted) return;
      showErrorDialog(context: context, message: '네이버 로그인 오류: ${e.message}');
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context: context, message: '네이버 로그인 중 오류가 발생했습니다.');
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
                        return '아이디를 입력해주세요';
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
                        onPressed: () {
                          signInWithKakao();
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: SocialLoginButton(
                          src: 'asset/img/login/naver_icon.png',
                          type: 'naver',
                          onPressed: () {
                            signInWithNaver();
                          },
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
