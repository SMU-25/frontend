import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/homecam/component/no_home_cam_view.dart';
import 'package:team_project_front/homecam/model/home_cam.dart';
import 'package:team_project_front/homecam/view/create_home_cam.dart';
import 'package:team_project_front/homecam/view/delete_home_cam.dart';
import 'package:team_project_front/homecam/view/home_cam.dart';

class HomeCamListScreen extends StatelessWidget {
  const HomeCamListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<HomeCam> homeCams = [
      HomeCam(
        name: '준형의 홈캠',
        place: '안방',
        childId: 1,
        childName: '준형',
        serialNum: 'ABC1234',
        videoUrl: 'test',
        createdAt: DateTime(2025, 4, 8),
      ),
      HomeCam(
        name: '강민의 홈캠',
        place: '거실',
        childId: 2,
        childName: '강민',
        serialNum: 'ABC1234',
        videoUrl: 'test',
        createdAt: DateTime(2025, 4, 9),
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children:
              homeCams.isEmpty
                  ? [
                    NoHomeCamView(),
                    const SizedBox(height: 16),
                    _buildAddButton(context),
                  ]
                  : [
                    ...homeCams.map((cam) => _buildHomeCamCard(context, cam)),
                    const SizedBox(height: 16),
                    _buildAddButton(context),
                  ],
        ),
      ),
    );
  }

  Widget _buildHomeCamCard(BuildContext context, HomeCam cam) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: INPUT_BORDER_COLOR),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cam.name,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  '설치 장소: ${cam.place}',
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  '아이: ${cam.childName}',
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  '기기 번호: ${cam.serialNum}',
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  '등록일: ${_formatDate(cam.createdAt)}',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 30),
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => HomeCamScreen()));
                },
              ),
              const SizedBox(height: 45),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 30),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              DeleteHomeCamScreen(homeCamName: cam.childName),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => CreateHomeCamScreen()));
      },
      child: Container(
        width: double.infinity,
        height: 80,
        margin: const EdgeInsets.only(bottom: 32),
        decoration: BoxDecoration(
          border: Border.all(color: INPUT_BORDER_COLOR),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(Icons.add, color: MAIN_COLOR, size: 40),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
