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

  final double bodyTemperature;
  final double feverThreshold;
  final double airTemperature;
  final double humidity;

  final Color Function(bool) getStatusColor;

  final bool isFever;
  final String comfortStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: INPUT_BORDER_COLOR),
        borderRadius: BorderRadius.circular(17),
        color: isFever ? Color.fromARGB(255, 255, 222, 220) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '환경',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Row(
            children: [
              Text('최근 측정 :', style: TextStyle(color: Colors.grey)),
              Text('1분 전', style: TextStyle(color: Colors.grey)),
            ],
          ),
          Row(
            children: [Icon(Icons.thermostat), SizedBox(width: 2), Text('기온')],
          ),
          Text(
            '$airTemperature℃',
            style: TextStyle(
              color: getStatusColor(isFever),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Icon(Icons.water_drop, size: 20),
              SizedBox(width: 2),
              Text('습도'),
            ],
          ),
          Text(
            '$humidity%',
            style: TextStyle(
              color:
                  (humidity < 40 || humidity > 60)
                      ? HIGH_FEVER_COLOR
                      : MAIN_COLOR,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            comfortStatus,
            style: TextStyle(
              color:
                  (humidity < 40 || humidity > 60)
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
                  builder: (context) => RoomTemperatureHumidityGraphScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 26),
              backgroundColor:
                  (humidity < 40 ||
                          humidity > 60 ||
                          bodyTemperature >= feverThreshold)
                      ? HIGH_FEVER_COLOR
                      : MAIN_COLOR,
            ),
            child: Text(
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
