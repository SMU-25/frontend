import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:team_project_front/common/component/temperature_chart_widget.dart';
import 'package:team_project_front/homecam/model/home_cam.dart';

class HomeCamView extends StatefulWidget {
  const HomeCamView({super.key, required this.homeCamData});

  final HomeCam homeCamData;

  @override
  State<HomeCamView> createState() => _HomeCamViewState();
}

class _HomeCamViewState extends State<HomeCamView> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2006),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String selectedDateText = DateFormat(
      'yyyy년 MM월 dd일',
    ).format(selectedDate);

    return SingleChildScrollView(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child:
                widget.homeCamData.videoUrl != null &&
                        widget.homeCamData.videoUrl!.isNotEmpty
                    ? Mjpeg(
                      stream: widget.homeCamData.videoUrl!,
                      isLive: true,
                      timeout: const Duration(seconds: 5),
                    )
                    : const Center(child: Text("스트리밍 URL 없음")),
          ),
          const SizedBox(height: 12),
          const Text(
            '방 온도/습도 그래프',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          TextButton(
            onPressed: () => _selectDate(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(selectedDateText),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          const _ChartSectionWidget(chartType: ChartType.roomTemp),
          const _ChartSectionWidget(chartType: ChartType.humidity),
        ],
      ),
    );
  }
}

class _ChartSectionWidget extends StatelessWidget {
  const _ChartSectionWidget({required this.chartType});

  final ChartType chartType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      // TemperatureChartWidget(chartType: chartType),
    );
  }
}
