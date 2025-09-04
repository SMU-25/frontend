import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/utils/secure_storage_service.dart';
import 'package:team_project_front/common/utils/error_dialog.dart';
import 'package:team_project_front/homecam/component/home_cam_view.dart';
import 'package:team_project_front/homecam/model/home_cam.dart';
import 'package:team_project_front/homecam/view/update_home_cam.dart';

class HomeCamScreen extends StatefulWidget {
  const HomeCamScreen({super.key, required this.homeCamId});

  final int homeCamId;

  @override
  State<HomeCamScreen> createState() => _HomeCamScreenState();
}

class _HomeCamScreenState extends State<HomeCamScreen> {
  HomeCam? _detailData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final dio = Dio();
      final token = await SecureStorageService.getAccessToken();

      final res = await dio.get(
        '$base_URL/homecams/${widget.homeCamId}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (!mounted) return;

      if (res.statusCode == 200) {
        final m = (res.data['result'] ?? {}) as Map<String, dynamic>;
        final detail = HomeCam(
          name: m['name'] ?? '',
          place: m['place'] ?? '',
          childId: m['childId'] as int? ?? 0,
          childName: m['childName'] ?? '',
          serialNum: m['serialNum'] ?? '',
          videoUrl: m['video_url'] ?? '',
          createdAt: DateTime.tryParse(m['createdAt'] ?? '') ?? DateTime.now(),
          homecamId: m['homecamId'] as int? ?? 0,
        );

        setState(() {
          _detailData = detail;
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
        showErrorDialog(context: context, message: '홈캠 정보를 불러오지 못했습니다.');
      }
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      final msg = e.response?.data['message'] ?? '알 수 없는 오류가 발생했습니다.';
      showErrorDialog(context: context, message: msg);
    }
  }

  Future<void> _goEdit() async {
    if (_detailData == null) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => UpdateHomeCamScreen(
              homeCamId: widget.homeCamId,
              initialChildId: _detailData!.childId,
              initialName: _detailData!.name,
              initialPlace: _detailData!.place,
              initialSerialNum: _detailData!.serialNum,
            ),
      ),
    );
    if (mounted) _fetchDetail();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_detailData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('홈캠')),
        body: const Center(child: Text('홈캠 정보를 표시할 수 없습니다.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _detailData!.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, size: 30),
            onPressed: _goEdit,
          ),
        ],
      ),

      body: HomeCamView(homeCamData: _detailData!),
    );
  }
}
