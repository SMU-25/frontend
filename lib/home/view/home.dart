import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/common/network/dio_client.dart';
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
import 'package:team_project_front/home/provider/selected_baby_provider.dart';
import 'dart:io' show Platform;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final double feverThreshold = 38;

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
    _requestNotificationPermission();
    _bootstrap();
  }

  Future<void> _requestNotificationPermission() async {
    final deviceType = Platform.isIOS ? "IOS" : "ANDROID";
    // 포그라운드 표시 옵션(iOS)
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    try {
      // FCM 토큰 가져오기
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        // 서버에 전송
        final dio = buildAuthedDio();
        await dio.post(
          '/fcm-token',
          data: {"token": token, "deviceType": deviceType},
        );
        print('✅ FCM 토큰 서버 등록 완료');
      }
    } catch (e) {
      print('❌ FCM 토큰 전송 실패: $e');
    }

    FirebaseMessaging.onMessage.listen((message) {
      print('onMessage: ${message.notification?.title}');
    });
  }

  Future<RoomCondition?> fetchRoomConditionData(int childId) async {
    try {
      final dio = buildAuthedDio();
      final res = await dio.get('/rooms/$childId');
      if (res.statusCode == 200) {
        final data = (res.data['result'] ?? {}) as Map<String, dynamic>;
        return RoomCondition.fromJson(data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<FeverRecord?> fetchFeverRecordData(int childId) async {
    try {
      final dio = buildAuthedDio();
      final res = await dio.get('/feverRecords/$childId');

      if (res.statusCode == 200) {
        final data = res.data['result'] as Map<String, dynamic>?;
        if (data == null) return null;
        return FeverRecord.fromJson(data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<List<Baby>> fetchBabiesData() async {
    final dio = buildAuthedDio();
    final res = await dio.get('/children');
    if (res.statusCode == 200) {
      final list = res.data['result'] as List<dynamic>;
      return list.map((m) {
        final map = m as Map<String, dynamic>;
        return Baby.forList(
          childId: map['childId'] as int,
          name: map['name'] as String,
          profileImage: map['profileImage'] as String? ?? '',
        );
      }).toList();
    }
    return [];
  }

  Future<Baby?> fetchBabyData(int childId) async {
    try {
      final dio = buildAuthedDio();
      final res = await dio.get('/children/$childId');
      if (res.statusCode == 200) {
        final m = res.data['result'] as Map<String, dynamic>?;
        if (m == null) return null;
        return Baby.fromJson(m).copyWith(childId: childId);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // _bootstrap() 함수 수정

  Future<void> _bootstrap() async {
    setState(() => isLoading = true);

    final loadedBabies = await fetchBabiesData();

    if (!mounted) return;

    if (loadedBabies.isEmpty) {
      setState(() {
        babies = [];
        selectedBaby = null;
        isLoading = false;
      });
      return;
    }

    final savedId = ref.read(selectedBabyIdProvider);
    final initial = (savedId != null)
        ? loadedBabies.firstWhere(
            (b) => b.childId == savedId,
            orElse: () => loadedBabies.first,
          )
        : loadedBabies.first;

    final babyDetail = await fetchBabyData(initial.childId!);
    final fever = await fetchFeverRecordData(initial.childId!);
    final room = await fetchRoomConditionData(initial.childId!);
    if (!mounted) return;

    final finalBaby = babyDetail ?? initial;
    ref.read(selectedBabyIdProvider.notifier).set(finalBaby.childId);

    setState(() {
      babies = loadedBabies;
      selectedBaby = finalBaby;
      feverRecordData = fever;
      roomConditionData = room;
      isLoading = false;
    });
  }

  Future<void> _onBabySelected(Baby baby) async {
    if (!mounted) return;
    setState(() {
      selectedBaby = baby;
      isLoading = true;
    });

    // 전역 상태 업데이트 (세션 유지)

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
    ref.read(selectedBabyIdProvider.notifier).set(baby.childId);
  }

  @override
  Widget build(BuildContext context) {
    final isHuman = feverRecordData?.state ?? IsHuman.human;
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

    final feverRecordAgoText = (feverRecordData?.createdAt != null)
        ? dateConvert(feverRecordData!.createdAt!)
        : '없음';
    final roomConditionAgoText = (roomConditionData?.createdAt != null)
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
    final currentChildId = ref.watch(selectedBabyIdProvider);
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
                      isHuman: isHuman,
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
                                isHuman: isHuman,
                              ),
                              const SizedBox(height: 16),
                              FeverReportCard(
                                getStatusColor: getStatusColor,
                                isFever: isFever,
                                childId: currentChildId!,
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
