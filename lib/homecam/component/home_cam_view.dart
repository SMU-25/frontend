import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:team_project_front/homecam/model/home_cam.dart';

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
                      stream: widget.homeCamData.videoUrl!,
                      isLive: true,
                      timeout: const Duration(seconds: 5),
                    )
                    : const Center(child: Text("스트리밍 URL 없음")),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
