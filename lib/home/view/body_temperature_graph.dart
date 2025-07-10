import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/temperature_chart_widget.dart';
import 'package:intl/intl.dart';

class BodyTemperatureGraphScreen extends StatefulWidget {
  const BodyTemperatureGraphScreen({super.key});

  @override
  State<BodyTemperatureGraphScreen> createState() {
    return _BodyTemperatureGraphScreenState();
  }
}

class _BodyTemperatureGraphScreenState
    extends State<BodyTemperatureGraphScreen> {
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
    final String todayText = DateFormat('yyyy년 MM월 dd일').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('체온 그래프', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => _selectDate(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(todayText),
                SizedBox(width: 4),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),

          _ChartSectionWidget(chartType: ChartType.bodyTemp),
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
    return Column(
      children: [
        TemperatureChartWidget(chartType: chartType),
        SizedBox(height: 40),
      ],
    );
  }
}
