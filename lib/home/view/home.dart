import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/const/colors.dart';
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
import 'package:team_project_front/util/date_convert.dart';

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
    _bootstrap(); // 최초 로드
  }

  Future<RoomCondition?> fetchRoomConditionData(int childId) async {
    try {
      final dio = Dio();
      final token = await SecureStorageService.getAccessToken();
      final res = await dio.get(
        '$base_URL/rooms/$childId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (res.statusCode == 200) {
        final data = (res.data['result'] ?? {}) as Map<String, dynamic>;
        return RoomCondition(
          airTemperature: (data['temperature'] as num?)?.toDouble(),
          humidity: (data['humidity'] as num?)?.toDouble(),
          createdAt: DateTime.tryParse(data['createdAt'] as String? ?? ''),
        );
      }
      // 실패: null 반환
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<FeverRecord?> fetchFeverRecordData(int childId) async {
    try {
      final dio = Dio();
      final token = await SecureStorageService.getAccessToken();
      final res = await dio.get(
        '$base_URL/feverRecords/$childId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (res.statusCode == 200) {
        final data = (res.data['result'] ?? {}) as Map<String, dynamic>;
        final fever = (data['fever'] as num?)?.toDouble();
        final createdAtStr = data['createdAt'] as String?;
        if (fever == null || createdAtStr == null) return null;
        return FeverRecord(
          fever: fever,
          createdAt: DateTime.tryParse(createdAtStr) ?? DateTime.now(),
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<List<Baby>> fetchBabiesData() async {
    final dio = Dio();
    final token = await SecureStorageService.getAccessToken();
    final res = await dio.get(
      '$base_URL/children',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (res.statusCode == 200) {
      final list = List<Map<String, dynamic>>.from(res.data['result']);
      return list
          .map((m) {
            final childId = (m['childId'] as num?)?.toInt();
            return Baby.forList(
              childId: childId ?? -1,
              name: (m['name'] as String?) ?? '이름 미등록',
              profileImage: (m['profileImage'] as String?) ?? '',
            );
          })
          .where((b) => b.childId != -1)
          .toList();
    }
    return [];
  }

  Future<Baby?> fetchBabyData(int childId) async {
    try {
      final dio = Dio();
      final token = await SecureStorageService.getAccessToken();
      final res = await dio.get(
        '$base_URL/children/$childId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (res.statusCode == 200) {
        final m = res.data['result'] as Map<String, dynamic>;
        return Baby(
          childId: m['childId'],
          name: m['name'],
          birthDate:
              (m['birthdate'] != null)
                  ? DateTime.tryParse(m['birthdate'])
                  : null,
          height: (m['height'] as num?)?.toDouble(),
          weight: (m['weight'] as num?)?.toDouble(),
          gender: m['gender'] == 'FEMALE' ? Gender.female : Gender.male,
          seizure: m['seizure'],
          profileImage: m['profileImage'],
          illnessTypes: List<String>.from(m['illnessTypes'] ?? []),
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _bootstrap() async {
    setState(() => isLoading = true);
    final loadedBabies = await fetchBabiesData();

    if (!mounted) return;
    if (loadedBabies.isEmpty) {
      setState(() {
        babies = [];
        selectedBaby = null;
        roomConditionData = null;
        feverRecordData = null;
        isLoading = false;
      });
      return;
    }

    final first = loadedBabies.first;
    final babyDetail = await fetchBabyData(first.childId!);
    final fever = await fetchFeverRecordData(first.childId!);
    final room = await fetchRoomConditionData(first.childId!);

    if (!mounted) return;
    setState(() {
      babies = loadedBabies;
      selectedBaby = babyDetail ?? first;
      feverRecordData = fever;
      roomConditionData = room;
      isLoading = false;
    });
  }

  // 선택 변경도 동일 패턴
  Future<void> _onBabySelected(Baby baby) async {
    if (!mounted) return;
    setState(() {
      selectedBaby = baby;
      isLoading = true;
    });
    final id = baby.childId!;
    final babyDetail = await fetchBabyData(id);
    final fever = await fetchFeverRecordData(id);
    final room = await fetchRoomConditionData(id);

    if (!mounted) return;
    setState(() {
      selectedBaby = babyDetail ?? baby;
      feverRecordData = fever;
      roomConditionData = room;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (babies.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('등록된 아이가 없습니다. 아이를 먼저 등록해주세요.')),
      );
    }

    double? oneDecimal(double? v) =>
        v == null ? null : double.parse(v.toStringAsFixed(1));
    final slicedAirTemperature = oneDecimal(roomConditionData?.airTemperature);
    final slicedHumidity = oneDecimal(roomConditionData?.humidity);
    final slicedFever = oneDecimal(feverRecordData?.fever);

    final feverRecordAgoText =
        (feverRecordData?.createdAt != null)
            ? dateConvert(feverRecordData!.createdAt!)
            : '없음';
    final roomConditionAgoText =
        (roomConditionData?.createdAt != null)
            ? dateConvert(roomConditionData!.createdAt!)
            : '없음';

    final isFever = (slicedFever != null && slicedFever >= feverThreshold);
    final isUncomfortableHumidity =
        (slicedHumidity != null) &&
        (slicedHumidity < 40 || slicedHumidity > 60);

    final comfortStatus =
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
                  onBabySelected: _onBabySelected,
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
                                feverRecordAgoText: feverRecordAgoText,
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
                                roomConditionAgoText: roomConditionAgoText,
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
