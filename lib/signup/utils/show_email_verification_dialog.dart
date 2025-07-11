import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/utils/error_dialog.dart';
import 'package:team_project_front/common/utils/loading_spinner.dart';

Future<void> showEmailVerificationDialog({
  required BuildContext context,
  required String email,
  required VoidCallback onVerified,
}) async {
  final TextEditingController codeController = TextEditingController();

  await showDialog(
    context: context,
    builder:
        (ctx) => AlertDialog(
          title: Text('인증번호 입력'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('이메일로 전송된 인증번호를 입력해주세요'),
              SizedBox(height: 16),
              TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '인증번호 6자리',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final code = codeController.text.trim();
                if (code.isEmpty) {
                  Navigator.of(ctx).pop();
                  showErrorDialog(context: context, message: '인증번호를 입력해주세요');
                  return;
                }

                try {
                  showLoadingDialog(context);
                  final dio = Dio();
                  final res = await dio.post(
                    '$base_URL/email/verification-code/validation',
                    data: {'email': email, 'code': code},
                  );
                  if (context.mounted) Navigator.of(context).pop();
                  if (context.mounted) Navigator.of(ctx).pop();

                  if (res.statusCode == 200) {
                    onVerified();
                  } else {
                    showErrorDialog(context: context, message: '인증에 실패했습니다');
                  }
                } on DioException catch (err) {
                  if (context.mounted) Navigator.of(context).pop();
                  if (context.mounted) Navigator.of(ctx).pop();
                  String message = '알 수 없는 오류가 발생했습니다.';
                  if (err.response?.data != null) {
                    message = err.response?.data['message'] ?? message;
                  }
                  showErrorDialog(context: context, message: message);
                }
              },
              child: Text('확인'),
            ),
          ],
        ),
  );
}
