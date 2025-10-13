import 'package:fl_chart/fl_chart.dart';

class FeverGraphData {
  final List<double> fever;

  FeverGraphData({required this.fever});

  List<FlSpot> toFeverSpots() {
    return fever
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
  }
}
