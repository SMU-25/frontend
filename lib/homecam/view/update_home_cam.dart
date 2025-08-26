import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/custom_navigation_bar.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/utils/secure_storage_service.dart';
import 'package:team_project_front/common/utils/error_dialog.dart';
import 'package:team_project_front/common/view/root_tab.dart';
import 'package:team_project_front/homecam/component/home_cam_form.dart';

class UpdateHomeCamScreen extends StatefulWidget {
  const UpdateHomeCamScreen({
    super.key,
    required this.homeCamId,
    this.initialChildId,
    this.initialName,
    this.initialPlace,
    this.initialSerialNum,
  });

  final int homeCamId;
  final int? initialChildId;
  final String? initialName;
  final String? initialPlace;
  final String? initialSerialNum;

  @override
  State<UpdateHomeCamScreen> createState() => _UpdateHomeCamScreenState();
}

class _UpdateHomeCamScreenState extends State<UpdateHomeCamScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController installationPlaceController =
      TextEditingController();
  final TextEditingController homeCamSerialNumController =
      TextEditingController();

  String? selectedChild;

  @override
  void initState() {
    super.initState();
    selectedChild = widget.initialChildId?.toString();
    nameController.text = widget.initialName ?? '';
    installationPlaceController.text = widget.initialPlace ?? '';
    homeCamSerialNumController.text = widget.initialSerialNum ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    installationPlaceController.dispose();
    homeCamSerialNumController.dispose();
    super.dispose();
  }

  void onChildChanged(String? value) {
    setState(() {
      selectedChild = value;
    });
  }

  Future<void> updateHomeCam() async {
    try {
      if (!(formKey.currentState?.validate() ?? false)) return;
      if (selectedChild == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('아이를 선택해주세요')));
        return;
      }

      final dio = Dio();
      final token = await SecureStorageService.getAccessToken();
      print(widget.homeCamId);
      final res = await dio.patch(
        '$base_URL/homecams/${widget.homeCamId}',
        data: {
          'childId': int.parse(selectedChild!),
          'serialNum': homeCamSerialNumController.text.trim(),
          'name': nameController.text.trim(),
          'place': installationPlaceController.text.trim(),
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (!mounted) return;

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('홈캠이 성공적으로 수정되었습니다!')));
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const RootTab(initialTabIndex: 1)),
          (route) => false,
        );
      } else {
        showErrorDialog(context: context, message: '홈캠 수정에 실패했습니다.');
      }
    } on DioException catch (err) {
      if (!mounted) return;
      final message = err.response?.data['message'] ?? '알 수 없는 오류가 발생했습니다.';
      showErrorDialog(context: context, message: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '홈캠 수정',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: HomeCamForm(
        formKey: formKey,
        nameController: nameController,
        installationPlaceController: installationPlaceController,
        serialNumController: homeCamSerialNumController,
        selectedChild: selectedChild,
        onChildChanged: onChildChanged,
        onSubmit: updateHomeCam,
        navigateText: '수정 완료',
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => RootTab(initialTabIndex: index)),
          );
        },
      ),
    );
  }
}
