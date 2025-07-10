import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/custom_navigation_bar.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/common/view/root_tab.dart';

class DeleteHomeCamScreen extends StatelessWidget {
  const DeleteHomeCamScreen({super.key, required this.homeCamName});
  final String homeCamName;

  @override
  Widget build(BuildContext context) {
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
                '‘$homeCamName’의 홈캠의 모든 데이터가 삭제되며\n복구가 불가합니다.\n정말 삭제하시겠습니까?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildConfirmButton(
                    text: '확인',
                    color: MAIN_COLOR,
                    textColor: Colors.white,
                    onTap: () {
                      // 삭제 API 연결 추가
                      // Navigator.of(context).pop();
                    },
                  ),
                  _buildConfirmButton(
                    text: '취소',
                    color: const Color.fromARGB(255, 202, 248, 245),
                    textColor: MAIN_COLOR,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
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
  }) {
    return ElevatedButton(
      onPressed: onTap,
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
