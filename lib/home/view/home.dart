import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/common/model/user.dart' hide Gender;
import 'package:team_project_front/common/utils/error_dialog.dart';
import 'package:team_project_front/common/utils/secure_storage_service.dart';
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

  List<Baby> babies = [];
  Baby? selectedBaby;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBabies();
  }

  Future<void> fetchBabies() async {
    try {
      final dio = Dio();
      final token = await SecureStorageService.getAccessToken();

      final res = await dio.get(
        '$base_URL/children',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (res.statusCode == 200) {
        List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
          res.data['result'],
        );

        final loadedBabies =
            data
                .map(
                  (baby) => Baby.forList(
                    childId: baby['childId'],
                    name: baby['name'],
                    profileImage: baby['profileImage'],
                  ),
                )
                .toList();

        setState(() {
          babies = loadedBabies;
          selectedBaby = babies[0];
          isLoading = true;
        });

        if (selectedBaby?.childId != null) {
          await fetchBaby(selectedBaby!.childId!);
        }
      } else {
        if (!mounted) return;
        showErrorDialog(context: context, message: '아이들 불러오기에 실패했습니다.');
      }
    } on DioException catch (err) {
      final message = err.response?.data['message'] ?? '알 수 없는 오류가 발생했습니다.';
      if (!mounted) return;
      showErrorDialog(context: context, message: message);
    }
  }

  Future<void> fetchBaby(int childId) async {
    try {
      final dio = Dio();
      final token = await SecureStorageService.getAccessToken();

      final res = await dio.get(
        '$base_URL/children/$childId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (res.statusCode == 200) {
        final babyData = res.data['result'];
        setState(() {
          selectedBaby = Baby(
            childId: babyData['childId'],
            name: babyData['name'],
            birthDate:
                babyData['birthdate'] != null
                    ? DateTime.parse(babyData['birthdate'])
                    : null,
            height: (babyData['height'] as num?)?.toDouble(),
            weight: (babyData['weight'] as num?)?.toDouble(),
            gender:
                babyData['gender'] == 'FEMALE' ? Gender.female : Gender.male,
            seizure: babyData['seizure'],
            profileImage: babyData['profileImage'],
            illnessTypes: List<String>.from(babyData['illnessTypes'] ?? []),
          );
          isLoading = false;
        });
      } else {
        if (!mounted) return;
        showErrorDialog(context: context, message: '아이 정보를 불러오지 못했습니다.');
      }
    } on DioException catch (err) {
      final message = err.response?.data['message'] ?? '알 수 없는 오류가 발생했습니다.';
      if (!mounted) return;
      showErrorDialog(context: context, message: message);
    }
  }

  @override
  Widget build(BuildContext context) {
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

    if (selectedBaby == null || isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 25,
                  right: 25,
                  bottom: 20,
                ),
                child: HomeHeader(
                  babies: babies,
                  selectedBaby: selectedBaby!,
                  onBabySelected: (baby) async {
                    setState(() {
                      selectedBaby = baby;
                      isLoading = true;
                    });
                    await fetchBaby(baby.childId!);
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    MainInfoCard(
                      baby: selectedBaby!,
                      bodyTemperature: bodyTemperature,
                      feverThreshold: feverThreshold,
                      airTemperature: airTemperature,
                      humidity: humidity,
                      getStatusColor: getStatusColor,
                      isFever: isFever,
                      isUncomfortableHumidity: isUncomfortableHumidity,
                    ),
                    const SizedBox(height: 16),
                    Row(
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
                              const SizedBox(height: 16),
                              FeverReportCard(
                                getStatusColor: getStatusColor,
                                isFever: isFever,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
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
                              const SizedBox(height: 16),
                              const SubscribeCard(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
