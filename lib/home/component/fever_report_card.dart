import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class FeverReportCard extends StatelessWidget {
  const FeverReportCard({
    super.key,
    required this.getStatusColor,
    required this.isFever,
  });

  final bool isFever;

  final Color Function(bool) getStatusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: INPUT_BORDER_COLOR),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '발열 리포트',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 8),
          Text('복잡한 발열 기록?\n걱정 마세요!\n\n리포트 한 장이면 병원에서도 OK!'),
          SizedBox(height: 12),

          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/report');
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 40),
              backgroundColor: MAIN_COLOR,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 5,
              foregroundColor: Colors.white,
            ),
            child: Text(
              '리포트 생성',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
