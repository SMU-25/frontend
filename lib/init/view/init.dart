import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/common/network/dio_client.dart';
import 'package:team_project_front/common/utils/secure_storage_service.dart';
import 'package:dio/dio.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});
  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  double logoSize = 250;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(milliseconds: 600)); // 로고 잠깐 표시
    final access = await SecureStorageService.getAccessToken();
    final refresh = await SecureStorageService.getRefreshToken();
    if (access != null && refresh != null) {
      try {
        final dio = buildAuthedDio();

        final resp = await dio.get(
          '/my',
          options: Options(validateStatus: (_) => true),
        );

        if (resp.statusCode == 200) {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/home');
          return;
        }
      } catch (e) {
        // 통신 에러 등은 아래에서 로그인 화면으로
      }
    }

    if (!mounted) return;
    setState(() => _isChecking = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'asset/img/logo/mom_fill_logo.png',
                height: logoSize,
                width: logoSize,
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(color: MAIN_COLOR),
            ],
          ),
        ),
      );
    }

    // 자동 로그인 실패 → 수동 시작 버튼
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/mom_fill_logo.png',
              height: logoSize,
              width: logoSize,
            ),
            Text(
              '맘편해',
              style: TextStyle(
                color: MAIN_COLOR,
                fontSize: 80,
                fontFamily: 'BMJUA',
              ),
            ),
            Text(
              '우리 아이 체온 관리 앱',
              style: TextStyle(
                color: MAIN_COLOR,
                fontSize: 25,
                fontFamily: 'BMJUA',
              ),
            ),
            const SizedBox(height: 200),
            NavigationButton(
              text: '시작',
              onPressed: () => Navigator.pushNamed(context, '/login'),
            ),
          ],
        ),
      ),
    );
  }
}
