import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/home/view/body_temperature_graph.dart';

class BodyTemperatureCard extends StatelessWidget {
  // 최근 시간
  const BodyTemperatureCard({
    super.key,
    required this.bodyTemperature,
    required this.feverThreshold,
    required this.getStatusColor,
    required this.isFever,
    this.elapsedFeverRecordSec,
  });
  final double? bodyTemperature;
  final double feverThreshold;
  final int? elapsedFeverRecordSec;

  final bool isFever;

  final Color Function(bool) getStatusColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 215,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: INPUT_BORDER_COLOR),
        borderRadius: BorderRadius.circular(15),
        color:
            bodyTemperature != null && bodyTemperature! >= feverThreshold
                ? Color.fromARGB(255, 255, 222, 220)
                : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '체온',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Row(
            children: [
              Text('최근 측정 :', style: TextStyle(color: Colors.grey)),
              Text(
                // '$elapsedFeverRecordSec 초전',
                '1분전',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          bodyTemperature != null
              ? Text(
                '${bodyTemperature!.toStringAsFixed(1)}℃',
                style: TextStyle(
                  color: getStatusColor(isFever),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              )
              : const Text(
                '데이터 없음',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
          Text(
            bodyTemperature != null && bodyTemperature! >= feverThreshold
                ? '열나요'
                : '정상이에요',
            style: TextStyle(
              color: getStatusColor(isFever),

              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BodyTemperatureGraphScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 26),
              backgroundColor: getStatusColor(
                bodyTemperature != null && bodyTemperature! >= feverThreshold,
              ),
            ),
            child: Text(
              '체온 그래프',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
