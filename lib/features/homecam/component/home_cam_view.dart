import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:team_project_front/core/network/dio_client.dart';
import 'package:team_project_front/features/home/model/fever_record_data.dart';
import 'package:team_project_front/features/home/model/room_condition.dart';
import 'package:team_project_front/features/homecam/component/state_info_card.dart';
import 'package:team_project_front/features/homecam/model/home_cam.dart';
import 'dart:async';

class HomeCamView extends StatefulWidget {
  const HomeCamView({super.key, required this.homeCamData});

  final HomeCam homeCamData;

  @override
  State<HomeCamView> createState() => _HomeCamViewState();
}

class _HomeCamViewState extends State<HomeCamView> {
  DateTime selectedDate = DateTime.now();

  final String selectedDateText = DateFormat(
    'yyyy년 MM월 dd일',
  ).format(DateTime.now());

  int _reload = 0;
  Timer? _timer;

  RoomCondition? _roomCondition;
  FeverRecord? _feverRecord;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLatest();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _loadLatest();
    });
  }

  @override
  void dispose() {
    // 메모리 누수 제거 (화면 벗어나면 타이머 제거)
    super.dispose();
    _timer?.cancel();
  }

  Future<void> _loadLatest() async {
    setState(() => _isLoading = true);
    try {
      final childId = widget.homeCamData.childId;
      final room = await fetchRoomConditionData(childId);
      final fever = await fetchFeverRecordData(childId);
      if (!mounted) return;
      setState(() {
        _roomCondition = room;
        _feverRecord = fever;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<RoomCondition?> fetchRoomConditionData(int childId) async {
    try {
      final dio = buildAuthedDio();

      final res = await dio.get('/rooms/$childId');
      if (res.statusCode == 200) {
        final data = res.data['result'] as Map<String, dynamic>?;
        if (data == null) return null;
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child:
                widget.homeCamData.videoUrl != null &&
                    widget.homeCamData.videoUrl!.isNotEmpty
                ? Mjpeg(
                    key: ValueKey(
                      'mjpeg_${_reload}_${widget.homeCamData.videoUrl}',
                    ),
                    stream: widget.homeCamData.videoUrl!,
                    isLive: true,
                    timeout: const Duration(seconds: 5),

                    // 연결 시 로딩 표시
                    loading: (_) => const _StatusPanel(
                      icon: Icons.wifi_tethering,
                      message: '스트림 연결 중…',
                      busy: true,
                    ),

                    // 연결 실패/타임아웃 등 에러 처리 + 재시도
                    error:
                        (
                          BuildContext context,
                          dynamic error,
                          dynamic stackTrace,
                        ) {
                          return _StatusPanel(
                            icon: Icons.error_outline,
                            message: _prettyError(error),
                            onRetry: () => setState(() => _reload++),
                          );
                        },
                  )
                : const Center(child: Text("스트리밍 URL 없음")),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatInfoCard(
                  title: '최근 체온',
                  isLoading: _isLoading,
                  value: _feverRecord?.fever,
                  unit: '℃',
                  timestamp: _feverRecord?.createdAt,
                  icon: Icons.thermostat,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 12),
                StatInfoCard(
                  title: '최근 온도',
                  isLoading: _isLoading,
                  value: _roomCondition?.airTemperature,
                  unit: '℃',
                  timestamp: _roomCondition?.createdAt,
                  icon: Icons.device_thermostat,
                  color: Colors.orangeAccent,
                ),
                const SizedBox(height: 12),
                StatInfoCard(
                  title: '최근 습도',
                  isLoading: _isLoading,
                  value: _roomCondition?.humidity,
                  unit: '%',
                  timestamp: _roomCondition?.createdAt,
                  icon: Icons.water_drop,
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _prettyError(Object e) {
  final msg = e.toString();
  if (msg.contains('Timeout') || msg.contains('timeout')) {
    return '연결 시간이 초과됐어요. 네트워크 상태를 확인하고 다시 시도해 주세요.';
  }
  if (msg.contains('SocketException')) {
    return '네트워크 연결에 실패했어요. 와이파이/데이터를 확인해 주세요.';
  }
  if (msg.contains('401') || msg.contains('403')) {
    return '접근 권한이 없어요. 인증 정보 또는 권한을 확인해 주세요.';
  }
  if (msg.contains('404')) {
    return '스트림을 찾지 못했어요(404). URL을 확인해 주세요.';
  }
  if (msg.contains('HandshakeException')) {
    return '보안 연결(HTTPS) 문제로 실패했어요. 인증서/프로토콜을 확인해 주세요.';
  }
  return '스트림 연결에 실패했어요. 잠시 후 다시 시도해 주세요.';
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel({
    required this.icon,
    required this.message,
    this.busy = false,
    this.onRetry,
  });

  final IconData icon;
  final String message;
  final bool busy;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: Colors.grey),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            if (busy) const CircularProgressIndicator(),
            if (!busy && onRetry != null)
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('다시 시도'),
              ),
          ],
        ),
      ),
    );
  }
}
