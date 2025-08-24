import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/common/utils/error_dialog.dart';
import 'package:team_project_front/common/utils/secure_storage_service.dart';

class DeleteHomeCamScreen extends StatefulWidget {
  const DeleteHomeCamScreen({
    super.key,
    required this.homeCamName,
    required this.homeCamId,
  });

  final String homeCamName;
  final int homeCamId;

  @override
  State<DeleteHomeCamScreen> createState() => _DeleteHomeCamScreenState();
}

class _DeleteHomeCamScreenState extends State<DeleteHomeCamScreen> {
  bool _isDeleting = false;

  Future<void> _deleteHomeCam() async {
    if (_isDeleting) return;
    setState(() => _isDeleting = true);

    try {
      final dio = Dio();
      final token = await SecureStorageService.getAccessToken();
      final res = await dio.delete(
        '$base_URL/homecams/${widget.homeCamId}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (!mounted) return;

      if (res.statusCode == 200) {
        Navigator.of(context).pop(true);
      } else {
        setState(() => _isDeleting = false);
        showErrorDialog(context: context, message: '홈캠 삭제에 실패했습니다.');
      }
    } on DioException catch (err) {
      if (!mounted) return;
      final message = err.response?.data['message'] ?? '알 수 없는 오류가 발생했습니다.';
      setState(() => _isDeleting = false);
      showErrorDialog(context: context, message: message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isDeleting = false);
      showErrorDialog(context: context, message: '삭제 중 오류가 발생했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.homeCamName;

    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: INPUT_BORDER_COLOR),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '홈캠 삭제',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                '‘$name’의 홈캠 데이터가 삭제되며\n복구가 불가합니다.\n정말 삭제하시겠습니까?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildConfirmButton(
                    text: _isDeleting ? '삭제 중...' : '확인',
                    color: MAIN_COLOR,
                    textColor: Colors.white,
                    enabled: !_isDeleting,
                    onTap: _deleteHomeCam,
                  ),
                  _buildConfirmButton(
                    text: '취소',
                    color: const Color.fromARGB(255, 202, 248, 245),
                    textColor: MAIN_COLOR,
                    enabled: !_isDeleting,
                    onTap: () => Navigator.of(context).pop(false),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return ElevatedButton(
      onPressed: enabled ? onTap : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
      ),
    );
  }
}
