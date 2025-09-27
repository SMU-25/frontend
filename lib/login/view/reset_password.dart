import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/utils/error_dialog.dart';
import 'package:team_project_front/login/view/component/find_form_section.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return ResetPasswordScreenState();
  }
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool get isEmail =>
      EmailValidator.validate(_emailController.text) &&
      !RegExp(r'[ㄱ-ㅎㅏ-ㅣ가-힣]').hasMatch(_emailController.text);

  Future<void> _resetPassword() async {
    final dio = Dio(
      BaseOptions(
        baseUrl: base_URL,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    try {
      final res = await dio.post(
        '/auth/reset-password',
        data: {'email': _emailController.text.trim()},
      );

      final sc = res.statusCode ?? 0;
      if (sc < 200 || sc >= 300) {
        final serverMsg = (res.data is Map) ? res.data['message'] : null;
        if (!mounted) return;
        return showErrorDialog(
          context: context,
          message: serverMsg ?? '임시 비밀번호 발급 실패 (HTTP $sc)',
        );
      }

      // 정상 응답 처리
      if (!mounted) return;
      await showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('비밀번호 재설정 완료'),
              content: Text('임시 비밀번호가 이메일로 전송되었습니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // dialog 닫기
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  },
                  child: const Text('확인'),
                ),
              ],
            ),
      );
    } on DioException catch (e) {
      final serverMsg =
          (e.response?.data is Map) ? e.response?.data['message'] : null;
      if (!mounted) return;
      showErrorDialog(
        context: context,
        message: serverMsg ?? '네트워크 오류가 발생했습니다.',
      );
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context: context, message: '알 수 없는 오류가 발생했습니다.');
    }
  }

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
                _resetPassword();
              }
            },
          ),
        ),
      ),
    );
  }
}
