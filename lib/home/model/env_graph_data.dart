import 'package:fl_chart/fl_chart.dart';

class EnvironmentGraphData {
  final List<double> humidity;
  final List<double> temperature;

  EnvironmentGraphData({required this.humidity, required this.temperature});

  List<FlSpot> toHumiditySpots() {
    if (humidity.isEmpty) return [];
    return humidity
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
  }

  List<FlSpot> toTemperatureSpots() {
    if (temperature.isEmpty) return [];
    return temperature
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
  }
}
