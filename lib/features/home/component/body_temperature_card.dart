import 'package:flutter/material.dart';
import 'package:team_project_front/core/const/colors.dart';
import 'package:team_project_front/features/home/model/fever_record_data.dart';
import 'package:team_project_front/features/home/view/body_temperature_graph.dart';

class BodyTemperatureCard extends StatelessWidget {
  // 최근 시간
  const BodyTemperatureCard({
    super.key,
    required this.bodyTemperature,
    required this.feverThreshold,
    required this.getStatusColor,
    required this.isFever,
    required this.feverRecordAgoText,
    required this.isHuman,
  });
  final double? bodyTemperature;
  final double feverThreshold;
  final String? feverRecordAgoText;
  final bool isFever;
  final IsHuman isHuman;
  final Color Function(bool) getStatusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 215,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: INPUT_BORDER_COLOR),
        borderRadius: BorderRadius.circular(15),
        color: bodyTemperature != null && bodyTemperature! >= feverThreshold
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
              const SizedBox(width: 8),
              Text(feverRecordAgoText!, style: TextStyle(color: Colors.grey)),
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
            bodyTemperature == null
                ? '데이터 없음'
                : isHuman == IsHuman.notHuman
                ? '잘못된 측정!'
                : (bodyTemperature! >= feverThreshold ? '열나요' : '정상이에요'),
            style: TextStyle(
              color: bodyTemperature == null
                  ? Colors.grey
                  : getStatusColor(isFever),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BodyTemperatureGraphScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 40),
              backgroundColor: getStatusColor(
                bodyTemperature != null && bodyTemperature! >= feverThreshold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 5,
              foregroundColor: Colors.white,
            ),
            child: Text(
              '체온 그래프',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
