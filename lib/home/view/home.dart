import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/home/component/body_temperature_card.dart';
import 'package:team_project_front/home/component/environment_card.dart';
import 'package:team_project_front/home/component/fever_report_card.dart';
import 'package:team_project_front/home/component/home_header.dart';
import 'package:team_project_front/home/component/main_info_card.dart';
import 'package:team_project_front/home/component/subscribe_card.dart';
import 'package:team_project_front/common/model/baby.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final double bodyTemperature = 39;
  final double airTemperature = 22;
  final double humidity = 25;
  final double feverThreshold = 37.5;

  Color getStatusColor(bool condition) =>
      condition ? HIGH_FEVER_COLOR : MAIN_COLOR;

  @override
  Widget build(BuildContext context) {
    // mock data
    final baby = Baby(
      name: '준형이',
      birthDate: DateTime(2023, 11, 9),
      height: 75.0,
      weight: 9.5,
      gender: Gender.male,
      seizure: '없음',
      profileImage: 'test',
      illnessTypes: ['아토피', '천식'],
    );
    final isFever = bodyTemperature >= feverThreshold;
    final isUncomfortableHumidity = humidity < 40 || humidity > 60;
    final comfortStatus =
        (humidity > 60)
            ? (airTemperature > 24
                ? '덥고 습해요'
                : airTemperature < 22
                ? '춥고 습해요'
                : '습해요')
            : (humidity < 40)
            ? (airTemperature > 24
                ? '덥고 건조해요'
                : airTemperature < 22
                ? '춥고 건조해요'
                : '건조해요')
            : (airTemperature <= 22 ? '추워요' : '쾌적해요 ☺️');
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 25,
                right: 25,
                bottom: 20,
              ),
              child: HomeHeader(),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 25, right: 25),
              child: Column(
                children: [
                  MainInfoCard(
                    baby: baby,
                    bodyTemperature: bodyTemperature,
                    feverThreshold: feverThreshold,
                    airTemperature: airTemperature,
                    humidity: humidity,
                    getStatusColor: getStatusColor,
                    isFever: isFever,
                    isUncomfortableHumidity: isUncomfortableHumidity,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              BodyTemperatureCard(
                                bodyTemperature: bodyTemperature,
                                feverThreshold: feverThreshold,
                                getStatusColor: getStatusColor,
                                isFever: isFever,
                              ),
                              SizedBox(height: 16),
                              FeverReportCard(
                                getStatusColor: getStatusColor,
                                isFever: isFever,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              EnvironmentCard(
                                bodyTemperature: bodyTemperature,
                                feverThreshold: feverThreshold,
                                airTemperature: airTemperature,
                                humidity: humidity,
                                getStatusColor: getStatusColor,
                                isFever: isFever,
                                comfortStatus: comfortStatus,
                              ),
                              SizedBox(height: 16),
                              SubscribeCard(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
