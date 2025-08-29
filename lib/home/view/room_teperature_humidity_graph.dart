import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_project_front/common/component/custom_navigation_bar.dart';
import 'package:team_project_front/common/component/temperature_chart_widget.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/utils/error_dialog.dart';
import 'package:team_project_front/common/utils/secure_storage_service.dart';
import 'package:team_project_front/common/view/root_tab.dart';
import 'package:team_project_front/homecam/model/home_cam.dart';

class RoomTemperatureHumidityGraphScreen extends StatefulWidget {
  const RoomTemperatureHumidityGraphScreen({super.key});

  @override
  State<RoomTemperatureHumidityGraphScreen> createState() =>
      _RoomTemperatureHumidityGraphScreenState();
}

class _RoomTemperatureHumidityGraphScreenState
    extends State<RoomTemperatureHumidityGraphScreen> {
  DateTime selectedDate = DateTime.now();

  bool _isLoading = false;
  int? _selectedHomecamId;

  Map<PeriodType, List<FlSpot>> _humidityChartData = {
    PeriodType.day1: const [],
    PeriodType.day3: const [],
    PeriodType.day7: const [],
  };

  Map<PeriodType, List<FlSpot>> _roomTempChartData = {
    PeriodType.day1: const [],
    PeriodType.day3: const [],
    PeriodType.day7: const [],
  };
  @override
  void initState() {
    super.initState();
    fetchHomecams();
  }

  Future<void> fetchHomecams() async {
    try {
      setState(() => _isLoading = true);

      final dio = Dio();
      final token = await SecureStorageService.getAccessToken();

      final res = await dio.get(
        '$base_URL/homecams/list',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (res.statusCode == 200) {
        final data = res.data['result'];
        final cams =
            (data as List)
                .map((e) => HomeCam.fromJson(e as Map<String, dynamic>))
                .toList();

        setState(() {
          _selectedHomecamId = cams.isNotEmpty ? cams.first.homecamId : null;
        });

        if (_selectedHomecamId != null) {
          await fetchGraph(_selectedHomecamId!);
        }
      } else {
        if (!mounted) return;
        showErrorDialog(context: context, message: '홈캠 기록을 불러오지 못했습니다.');
      }
    } on DioException catch (err) {
      final message = err.response?.data['message'] ?? '알 수 없는 오류가 발생했습니다.';
      if (!mounted) return;
      showErrorDialog(context: context, message: message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> fetchGraph(int homecamId) async {
    try {
      setState(() => _isLoading = true);

      final dio = Dio();
      final token = await SecureStorageService.getAccessToken();

      final res = await dio.get(
        '$base_URL/homecams/graph/$homecamId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (res.statusCode == 200) {
        final graphData = res.data['result'] as Map<String, dynamic>;
        final humidityParsed = _parseGraphData(
          graphData,
          seriesKey: 'humidity',
          valueKey: 'avghumidity',
        );

        // ✅ 온도 데이터 파싱
        final tempParsed = _parseGraphData(
          graphData,
          seriesKey: 'temperature',
          valueKey: 'avgtemperature',
        );

        setState(() {
          _humidityChartData = humidityParsed;
          _roomTempChartData = tempParsed;
        });
      } else {
        if (!mounted) return;
        showErrorDialog(context: context, message: '그래프 기록을 불러오지 못했습니다.');
      }
    } on DioException catch (err) {
      final message = err.response?.data['message'] ?? '알 수 없는 오류가 발생했습니다.';
      if (!mounted) return;
      showErrorDialog(context: context, message: message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 그래프 포맷 변환 헬퍼
  PeriodType _periodFromKey(String k) {
    switch (k) {
      case 'day1':
        return PeriodType.day1;
      case 'day3':
        return PeriodType.day3;
      case 'day7':
        return PeriodType.day7;
      default:
        return PeriodType.day1;
    }
  }

  List<FlSpot> _toSpotsFromAgg(List<dynamic>? list, String valueKey) {
    if (list == null) return const [];
    final result = <FlSpot>[];
    for (int i = 0; i < list.length; i++) {
      final item = list[i] as Map<String, dynamic>;
      final y = (item[valueKey] as num?)?.toDouble() ?? 0.0;
      result.add(FlSpot(i.toDouble(), y));
    }
    return result;
  }

  Map<PeriodType, List<FlSpot>> _parseGraphData(
    Map<String, dynamic> graphData, {
    required String seriesKey,
    required String valueKey,
  }) {
    final out = <PeriodType, List<FlSpot>>{};
    for (final periodEntry in graphData.entries) {
      final period = _periodFromKey(periodEntry.key);
      final body = (periodEntry.value as Map<String, dynamic>?);
      final list = body?[seriesKey] as List<dynamic>?;
      out[period] = _toSpotsFromAgg(list, valueKey);
    }
    // 누락된 기간은 빈 리스트로 보정
    out.putIfAbsent(PeriodType.day1, () => const []);
    out.putIfAbsent(PeriodType.day3, () => const []);
    out.putIfAbsent(PeriodType.day7, () => const []);
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final String selectedDateText = DateFormat(
      'yyyy년 MM월 dd일',
    ).format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '방 온도/습도 그래프',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(selectedDateText)],
                        ),
                      ),
                      const SizedBox(height: 16),

                      _ChartSectionWidget(
                        chartType: ChartType.humidity,
                        chartData: _humidityChartData,
                      ),

                      _ChartSectionWidget(
                        chartType: ChartType.roomTemp,
                        chartData: _roomTempChartData,
                      ),
                    ],
                  ),
                ),
              ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => RootTab(initialTabIndex: index)),
          );
        },
      ),
    );
  }
}

class _ChartSectionWidget extends StatelessWidget {
  const _ChartSectionWidget({required this.chartType, required this.chartData});

  final ChartType chartType;
  final Map<PeriodType, List<FlSpot>> chartData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TemperatureChartWidget(
          chartType: chartType,
          chartData: chartData,
          createdAt: DateTime.now(),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
