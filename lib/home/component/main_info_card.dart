import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/common/model/baby.dart';

class MainInfoCard extends StatelessWidget {
  const MainInfoCard({
    super.key,
    required this.baby,
    required this.bodyTemperature,
    required this.feverThreshold,
    required this.airTemperature,
    required this.humidity,
    required this.getStatusColor,
    required this.isFever,
    required this.isUncomfortableHumidity,
  });

  final Baby baby;
  final double bodyTemperature;
  final double feverThreshold;
  final double airTemperature;
  final double humidity;
  final Color Function(bool) getStatusColor;
  final bool isFever;
  final bool isUncomfortableHumidity;

  int _calculateMonths(DateTime birthDate) {
    final now = DateTime.now();
    final yearDiff = now.year - birthDate.year;
    final monthDiff = now.month - birthDate.month;
    final totalMonths = yearDiff * 12 + monthDiff;
    return totalMonths >= 0 ? totalMonths : 0;
  }

  @override
  Widget build(BuildContext context) {
    final months = _calculateMonths(baby.birthDate);

    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: INPUT_BORDER_COLOR),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: '${baby.name} / 생후 $months개월 / 오늘은 '),
                      TextSpan(
                        text: isFever ? '아파요 😢' : '건강해요! 😀',
                        style: TextStyle(color: getStatusColor(isFever)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.thermostat, color: getStatusColor(isFever)),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    const TextSpan(text: '체온 : '),
                    TextSpan(
                      text: '$bodyTemperature℃',
                      style: TextStyle(color: getStatusColor(isFever)),
                    ),
                  ],
                ),
              ),
              const Text('|'),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    const TextSpan(text: '기온 : '),
                    TextSpan(
                      text: '$airTemperature℃',
                      style: TextStyle(color: getStatusColor(isFever)),
                    ),
                  ],
                ),
              ),
              const Text('|'),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    const TextSpan(text: '습도 : '),
                    TextSpan(
                      text: '$humidity%',
                      style: TextStyle(
                        color: getStatusColor(
                          isFever || isUncomfortableHumidity,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
