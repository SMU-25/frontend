import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/common/utils/error_dialog.dart';
import 'package:team_project_front/common/utils/secure_storage_service.dart';
import 'package:team_project_front/home/component/body_temperature_card.dart';
import 'package:team_project_front/home/component/environment_card.dart';
import 'package:team_project_front/home/component/fever_report_card.dart';
import 'package:team_project_front/home/component/home_header.dart';
import 'package:team_project_front/home/component/main_info_card.dart';
import 'package:team_project_front/home/component/subscribe_card.dart';
import 'package:team_project_front/common/model/baby.dart';
import 'package:team_project_front/home/model/fever_record_data.dart';
import 'package:team_project_front/home/model/room_condition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final double feverThreshold = 37.5;

  Color getStatusColor(bool condition) =>
      condition ? HIGH_FEVER_COLOR : MAIN_COLOR;

  List<Baby> babies = [];
  Baby? selectedBaby;
  RoomCondition? roomConditionData;
  FeverRecord? feverRecordData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBabies();
  }

  Future<void> fetchRoomCondition(int childId) async {
    try {
      final dio = Dio();
      final token = await SecureStorageService.getAccessToken();

      final res = await dio.get(
        '$base_URL/rooms/$childId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (!mounted) return;

      if (res.statusCode == 200) {
        final data = (res.data['result'] ?? {}) as Map<String, dynamic>;

        final mappedData = RoomCondition(
          airTemperature: (data['temperature'] as num?)?.toDouble(),
          humidity: (data['humidity'] as num?)?.toDouble(),
          createdAt: DateTime.tryParse(data['createdAt'] as String? ?? ''),
        );

        setState(() {
          roomConditionData = mappedData;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        showErrorDialog(context: context, message: '온습도 기록을 불러오지 못했습니다.');
      }
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? '온습도 기록 불러오기에 실패했어요.';
      if (!mounted) return;
      showErrorDialog(context: context, message: msg);
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context: context, message: '알 수 없는 오류가 발생했어요.');
    }
  }

  Future<void> fetchFeverRecord(int childId) async {
    try {
      final dio = Dio();
      final token = await SecureStorageService.getAccessToken();

      final res = await dio.get(
        '$base_URL/feverRecords/$childId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (!mounted) return;

      if (res.statusCode == 200) {
        final data = (res.data['result'] ?? {}) as Map<String, dynamic>;

        final mappedData = FeverRecord(
          fever: (data['fever'] as num).toDouble(),
          createdAt: DateTime.parse(data['createdAt'] as String),
        );

        setState(() {
          feverRecordData = mappedData;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        showErrorDialog(context: context, message: '발열 기록을 불러오지 못했습니다.');
      }
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? '발열 기록 불러오기에 실패했어요.';
      if (!mounted) return;
      showErrorDialog(context: context, message: msg);
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context: context, message: '알 수 없는 오류가 발생했어요.');
    }
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
            data.map((raw) {
              final m = raw;

              final childId = (m['childId'] as num?)?.toInt();
              final name = (m['name'] as String?) ?? '이름 미등록';
              final profileImage = (m['profileImage'] as String?) ?? '';

              if (childId == null) {
                debugPrint('Invalid child item: $m');
                throw Exception('childId is null');
              }

              return Baby.forList(
                childId: childId,
                name: name,
                profileImage: profileImage,
              );
            }).toList();
        if (!mounted) return;
        setState(() {
          babies = loadedBabies;
        });
        if (babies.isEmpty) {
          // 아이가 없을 때: 선택/추가 UI로 유도하거나 빈 화면 처리
          setState(() {
            selectedBaby = null;
            isLoading = false;
          });
          return;
        }

        setState(() {
          selectedBaby = babies[0];
          isLoading = true;
        });

        final id = babies.first.childId;
        if (!mounted) return;
        setState(() {
          selectedBaby = babies.first;
          isLoading = true;
        });
        if (id != null) {
          await fetchBaby(id);
          await fetchFeverRecord(id);
          await fetchRoomCondition(id);
        }
        setState(() => isLoading = false);
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
    double? oneDecimal(double? value) {
      if (value == null) return null;
      return double.parse(value.toStringAsFixed(1));
    }

    final double? slicedAirTemperature = oneDecimal(
      roomConditionData?.airTemperature,
    );

    // final int? elapsedFeverRecordSec =
    //     (feverRecordData?.createdAt != null)
    //         ? DateTime.now().difference(feverRecordData!.createdAt!).inSeconds
    //         : null;

    // final int? elapsedRoomConditionSec =
    //     (roomConditionData?.createdAt != null)
    //         ? DateTime.now().difference(roomConditionData!.createdAt!).inSeconds
    //         : null;

    final double? slicedHumidity = oneDecimal(roomConditionData?.humidity);
    final double? slicedFever = oneDecimal(feverRecordData?.fever);
    final bool isFever = (slicedFever != null && slicedFever >= feverThreshold);
    final bool isUncomfortableHumidity =
        (slicedHumidity != null) &&
        (slicedHumidity < 40 || slicedHumidity > 60);

    final String comfortStatus =
        (slicedHumidity == null || slicedAirTemperature == null)
            ? '데이터 없음'
            : (slicedHumidity > 60)
            ? (slicedAirTemperature > 24
                ? '덥고 습해요'
                : slicedAirTemperature < 22
                ? '춥고 습해요'
                : '습해요')
            : (slicedHumidity < 40)
            ? (slicedAirTemperature > 24
                ? '덥고 건조해요'
                : slicedAirTemperature < 22
                ? '춥고 건조해요'
                : '건조해요')
            : (slicedAirTemperature <= 22 ? '추워요' : '쾌적해요 ☺️');

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (babies.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('등록된 아이가 없습니다. 아이를 먼저 등록해주세요.')),
      );
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
                    if (!mounted) return;
                    setState(() {
                      selectedBaby = baby;
                      isLoading = true;
                    });

                    final id = baby.childId;
                    if (id != null) {
                      await fetchBaby(id);
                      await fetchFeverRecord(id);
                      await fetchRoomCondition(id);
                    }

                    if (!mounted) return;
                    setState(() => isLoading = false);
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
                      bodyTemperature: slicedFever,
                      feverThreshold: feverThreshold,
                      airTemperature: slicedAirTemperature,
                      humidity: slicedHumidity,
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
                                bodyTemperature: slicedFever,
                                feverThreshold: feverThreshold,
                                getStatusColor: getStatusColor,
                                isFever: isFever,
                                // elapsedFeverRecordSec: elapsedFeverRecordSec,
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
                                bodyTemperature: slicedFever,
                                feverThreshold: feverThreshold,
                                airTemperature: slicedAirTemperature,
                                humidity: slicedHumidity,
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
