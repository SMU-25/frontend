import 'package:flutter/material.dart';
import 'package:team_project_front/core/const/colors.dart';
import 'package:team_project_front/core/model/baby.dart';
import 'package:team_project_front/features/home/data/models/fever_record_data.dart';

class MainInfoCard extends StatelessWidget {
  const MainInfoCard({
    super.key,
    required this.baby,
    this.bodyTemperature,
    required this.feverThreshold,
    this.airTemperature,
    this.humidity,
    required this.getStatusColor,
    required this.isFever,
    required this.isUncomfortableHumidity,
    required this.isHuman,
  });

  final Baby? baby;
  final double? bodyTemperature;
  final double feverThreshold;
  final double? airTemperature;
  final double? humidity;
  final Color Function(bool) getStatusColor;
  final bool isFever;
  final bool isUncomfortableHumidity;
  final IsHuman isHuman;

  (int value, bool isMonth) _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    final yearDiff = now.year - birthDate.year;
    final monthDiff = now.month - birthDate.month;
    final totalMonths = yearDiff * 12 + monthDiff;

    if (totalMonths <= 0) {
      final days = now.difference(birthDate).inDays;
      return (days < 0 ? 0 : days, false);
    }
    return (totalMonths, true);
  }

  @override
  Widget build(BuildContext context) {
    if (baby == null || baby!.birthDate == null) {
      return Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: INPUT_BORDER_COLOR),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Text(
            "아이 정보를 추가해 주세요",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    final (age, isMonth) = _calculateAge(baby!.birthDate!);
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
                      TextSpan(
                        text:
                            '${baby!.name} / 생후 $age${isMonth ? "개월" : "일"} / ',
                      ),
                      TextSpan(
                        text: bodyTemperature == null
                            ? '데이터 없음'
                            : isHuman == IsHuman.notHuman
                            ? '체온 데이터가 아니에요!'
                            : isFever
                            ? '오늘은 아파요 😢'
                            : '오늘은 건강해요! 😀',
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
                      text: bodyTemperature != null
                          ? '$bodyTemperature℃'
                          : '데이터 없음',
                      style: bodyTemperature != null
                          ? TextStyle(color: getStatusColor(isFever))
                          : TextStyle(color: Colors.grey),
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
                      text: airTemperature != null
                          ? '$airTemperature℃'
                          : '데이터 없음',
                      style: airTemperature != null
                          ? TextStyle(color: getStatusColor(isFever))
                          : TextStyle(color: Colors.grey),
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
                      text: humidity != null ? '$humidity%' : '데이터 없음',
                      style: humidity != null
                          ? TextStyle(
                              color: getStatusColor(
                                isFever || isUncomfortableHumidity,
                              ),
                            )
                          : TextStyle(color: Colors.grey),
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
