import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_project_front/common/component/custom_navigation_bar.dart';
import 'package:team_project_front/common/component/temperature_chart_widget.dart';
import 'package:team_project_front/common/view/root_tab.dart';

class RoomTemperatureHumidityGraphScreen extends StatefulWidget {
  const RoomTemperatureHumidityGraphScreen({super.key});

  @override
  State<RoomTemperatureHumidityGraphScreen> createState() =>
      _RoomTemperatureHumidityGraphScreenState();
}

class _RoomTemperatureHumidityGraphScreenState
    extends State<RoomTemperatureHumidityGraphScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final String selectedDateText = DateFormat(
      'yyyy년 MM월 dd일',
    ).format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '방 온도/습도 그래프',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => () {},
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(selectedDateText)],
              ),
            ),
            Image.asset('asset/img/graph/graph1.png'),
            // _ChartSectionWidget(chartType: ChartType.humidity, chartData:),
          ],
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
        SizedBox(height: 40),
      ],
    );
  }
}
