import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/home/view/room_teperature_humidity_graph.dart';

class EnvironmentCard extends StatelessWidget {
  const EnvironmentCard({
    super.key,
    required this.bodyTemperature,
    required this.feverThreshold,
    required this.airTemperature,
    required this.humidity,
    required this.getStatusColor,
    required this.isFever,
    required this.comfortStatus,
  });

  final double? bodyTemperature;
  final double? airTemperature;
  final double? humidity;
  final double feverThreshold;

  final Color Function(bool) getStatusColor;

  final bool isFever;
  final String comfortStatus;

  String _fmt1(double? v, String unit) =>
      v == null ? '데이터 없음' : '${v.toStringAsFixed(1)}$unit';

  TextStyle _styleFor(
    double? v,
    Color normalColor, {
    double normalSize = 30,
    double emptySize = 18,
  }) {
    return TextStyle(
      color: v == null ? Colors.grey : normalColor,
      fontSize: v == null ? emptySize : normalSize,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isAbnormalHumidity =
        (humidity != null) && (humidity! < 40 || humidity! > 60);
    final bool isFeverNow =
        (bodyTemperature != null) && (bodyTemperature! >= feverThreshold);

    return Container(
      height: 290,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: INPUT_BORDER_COLOR),
        borderRadius: BorderRadius.circular(17),
        color: isFeverNow ? const Color.fromARGB(255, 255, 222, 220) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '환경',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Row(
            children: const [
              Text('최근 측정 :', style: TextStyle(color: Colors.grey)),
              SizedBox(width: 6),
              Text('1분 전', style: TextStyle(color: Colors.grey)),
            ],
          ),
          Row(
            children: const [
              Icon(Icons.thermostat),
              SizedBox(width: 2),
              Text('기온'),
            ],
          ),
          Text(
            _fmt1(airTemperature, '℃'),
            style: _styleFor(airTemperature, getStatusColor(isFeverNow)),
          ),
          Row(
            children: const [
              Icon(Icons.water_drop, size: 20),
              SizedBox(width: 2),
              Text('습도'),
            ],
          ),
          Text(
            _fmt1(humidity, '%'),
            style: _styleFor(
              humidity,
              isAbnormalHumidity ? HIGH_FEVER_COLOR : MAIN_COLOR,
            ),
          ),
          Text(
            comfortStatus,
            style: TextStyle(
              color:
                  (isAbnormalHumidity || isFeverNow)
                      ? HIGH_FEVER_COLOR
                      : MAIN_COLOR,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => const RoomTemperatureHumidityGraphScreen(),
                ),
              );
            },
            style: TextButton.styleFrom(
              minimumSize: const Size(double.infinity, 26),
              backgroundColor:
                  (isAbnormalHumidity || isFeverNow)
                      ? HIGH_FEVER_COLOR
                      : MAIN_COLOR,
            ),
            child: const Text(
              '온습도 그래프',
              style: TextStyle(
                fontSize: 16,
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
