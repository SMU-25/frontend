import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/temperature_chart_widget.dart';
import 'package:intl/intl.dart';

class HomeCamView extends StatefulWidget {
  const HomeCamView({super.key});

  @override
  State<HomeCamView> createState() {
    return _HomeCamViewState();
  }
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
          Image.asset('asset/img/homecam_mock_data/mock.png'),
          SizedBox(height: 12),
          Text(
            '방 온도/습도 그래프',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          TextButton(
            onPressed: () => _selectDate(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(selectedDateText),
                SizedBox(width: 4),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          _ChartSectionWidget(chartType: ChartType.roomTemp),
          _ChartSectionWidget(chartType: ChartType.humidity),
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
      child: TemperatureChartWidget(chartType: chartType),
    );
  }
}
