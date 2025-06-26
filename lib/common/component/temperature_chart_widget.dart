import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

enum PeriodType { day1, day3, day7 }

class TemperatureChartWidget extends StatefulWidget {
  const TemperatureChartWidget({super.key});

  @override
  State<TemperatureChartWidget> createState() => _TemperatureChartWidgetState();
}

class _TemperatureChartWidgetState extends State<TemperatureChartWidget> {
  PeriodType selectedPeriod = PeriodType.day7;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ICON_GREY_COLOR.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          _buildSelector(),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 1.6,
            child: LineChart(_buildChartData()),
          ),
        ],
      ),
    );
  }

  Widget _buildSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: PeriodType.values.map((period) {
        final isSelected = selectedPeriod == period;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ElevatedButton(
            onPressed: () => setState(() => selectedPeriod = period),
            style: ElevatedButton.styleFrom(
              backgroundColor:
              isSelected ? MAIN_COLOR : MAIN_COLOR.withValues(alpha: 0.3),
              shape: const StadiumBorder(),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            ),
            child: Text(
              _label(period),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _label(PeriodType p) {
    switch (p) {
      case PeriodType.day1:
        return '1일';
      case PeriodType.day3:
        return '3일';
      case PeriodType.day7:
        return '7일';
    }
  }

  LineChartData _buildChartData() {
    final spots = _getSpots();
    final labels = _getLabels();

    return LineChartData(
      minY: 35,
      maxY: 40,
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, _) => Text('${value.toStringAsFixed(0)}°C', style: const TextStyle(fontSize: 9)),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 1,
            getTitlesWidget: (value, meta) {
              int idx = value.toInt();
              return SideTitleWidget(
                meta: meta,
                child: Text(
                  idx >= 0 && idx < labels.length ? labels[idx] : '',
                  style: const TextStyle(fontSize: 11),
                ),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(
        show: true,
        horizontalInterval: 0.5,
        getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey.shade300, strokeWidth: 1),
        getDrawingVerticalLine: (_) => FlLine(color: Colors.grey.shade200, strokeWidth: 1),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: const Color(0xFF64CCC5),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
        )
      ],
    );
  }

  List<FlSpot> _getSpots() {
    switch (selectedPeriod) {
      case PeriodType.day1:
        return [
          FlSpot(0, 36.0),
          FlSpot(1, 36.5),
          FlSpot(2, 37.0),
          FlSpot(3, 36.3),
          FlSpot(4, 36.7),
          FlSpot(5, 36.2),
          FlSpot(6, 36.5),
          FlSpot(7, 36.0),
        ];
      case PeriodType.day3:
        return [
          FlSpot(0, 36.1),
          FlSpot(1, 36.4),
          FlSpot(2, 36.7),
          FlSpot(3, 36.3),
          FlSpot(4, 36.8),
          FlSpot(5, 36.5),
          FlSpot(6, 36.9),
          FlSpot(7, 36.7),
          FlSpot(8, 36.6),
        ];
      case PeriodType.day7:
        return [
          FlSpot(0, 36.0),
          FlSpot(1, 36.5),
          FlSpot(2, 37.0),
          FlSpot(3, 36.3),
          FlSpot(4, 37.5),
          FlSpot(5, 37.0),
          FlSpot(6, 36.7),
        ];
    }
  }

  List<String> _getLabels() {
    switch (selectedPeriod) {
      case PeriodType.day1:
        return ['0시', '3시', '6시', '9시', '12시', '15시', '18시', '21시'];
      case PeriodType.day3:
        return ['1일\n새벽', '1일\n오전', '1일\n오후', '2일\n새벽', '2일\n오전', '2일\n오후', '3일\n새벽', '3일\n오전', '3일\n오후'];
      case PeriodType.day7:
        return ['7일', '8일', '9일', '10일', '11일', '12일', '13일'];
    }
  }
}
