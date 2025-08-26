import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/common/utils/error_dialog.dart';
import 'package:team_project_front/common/utils/secure_storage_service.dart';
import 'package:team_project_front/homecam/component/no_home_cam_view.dart';
import 'package:team_project_front/homecam/model/home_cam.dart';
import 'package:team_project_front/homecam/view/create_home_cam.dart';
import 'package:team_project_front/homecam/view/delete_home_cam.dart';
import 'package:team_project_front/homecam/view/home_cam.dart';

class HomeCamListScreen extends StatefulWidget {
  const HomeCamListScreen({super.key});

  @override
  State<HomeCamListScreen> createState() => _HomeCamListScreenState();
}

class _HomeCamListScreenState extends State<HomeCamListScreen> {
  bool _isLoading = true;
  List<HomeCam> _homeCams = [];

  @override
  void initState() {
    super.initState();
    _fetchHomeCams();
  }

  Future<void> _fetchHomeCams() async {
    try {
      final Dio dio = Dio();
      final token = await SecureStorageService.getAccessToken();
      final res = await dio.get(
        '$base_URL/homecams/list',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (!mounted) return;

      if (res.statusCode == 200) {
        final List data = (res.data['result'] ?? []) as List;

        final cams =
            data.map((e) {
              final m = e as Map<String, dynamic>;
              return HomeCam(
                name: m['name'] ?? '',
                place: m['place'] ?? '',
                childId: m['childId'] as int? ?? 0,
                childName: m['childName'] ?? '',
                serialNum: m['serialNum'] ?? '',
                createdAt:
                    DateTime.tryParse(m['createdAt'] ?? '') ?? DateTime.now(),
                homecamId: m['homecamId'] as int? ?? 0,
              );
            }).toList();
        setState(() {
          _homeCams = List<HomeCam>.from(cams);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        showErrorDialog(context: context, message: '홈캠 목록 불러오기에 실패했습니다.');
      }
    } on DioException catch (err) {
      if (!mounted) return;
      final message = err.response?.data['message'] ?? '알 수 없는 오류가 발생했습니다.';
      setState(() => _isLoading = false);
      debugPrint(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _fetchHomeCams,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            children:
                _homeCams.isEmpty
                    ? [
                      const NoHomeCamView(),
                      const SizedBox(height: 16),
                      _buildAddButton(context),
                    ]
                    : [
                      ..._homeCams.map(
                        (cam) => _buildHomeCamCard(context, cam),
                      ),
                      const SizedBox(height: 16),
                      _buildAddButton(context),
                    ],
          ),
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => HomeCamScreen(homeCamId: cam.homecamId),
                    ),
                  );
                },
              ),
              const SizedBox(height: 45),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 30),
                onPressed: () async {
                  final deleted = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder:
                          (_) => DeleteHomeCamScreen(
                            homeCamName: cam.childName,
                            homeCamId: cam.homecamId,
                          ),
                    ),
                  );
                  if (deleted == true && mounted) {
                    setState(() {
                      // 낙관적 업데이트 적용
                      _homeCams.removeWhere(
                        (c) => c.homecamId == cam.homecamId,
                      );
                    });
                    await _fetchHomeCams();
                  }
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
      onTap: () async {
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const CreateHomeCamScreen()));
        // 등록 후 돌아오면 목록 갱신
        if (mounted) _fetchHomeCams();
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
