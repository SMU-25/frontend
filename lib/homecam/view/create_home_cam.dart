import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/utils/error_dialog.dart';
import 'package:team_project_front/common/utils/secure_storage_service.dart';
import 'package:team_project_front/common/view/root_tab.dart';
import 'package:team_project_front/homecam/component/home_cam_form.dart';
import 'package:team_project_front/homecam/view/create_home_cam_complete.dart';
import 'package:team_project_front/common/component/custom_navigation_bar.dart';

class CreateHomeCamScreen extends StatefulWidget {
  const CreateHomeCamScreen({super.key});

  @override
  State<CreateHomeCamScreen> createState() => _CreateHomeCamScreenState();
}

class _CreateHomeCamScreenState extends State<CreateHomeCamScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController installationPlaceController =
      TextEditingController();
  final TextEditingController homeCamSerialNumController =
      TextEditingController();
  String? selectedChild;

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

  Future<void> createHomeCam() async {
    try {
      final dio = Dio();
      final token = await SecureStorageService.getAccessToken();

      final res = await dio.post(
        '$base_URL/homecams',
        data: {
          'childId': int.parse(selectedChild!),
          'serial_num': homeCamSerialNumController.text.trim(),
          'name': nameController.text.trim(),
          'place': installationPlaceController.text.trim(),
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (res.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('홈캠이 성공적으로 등록되었습니다!')));
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const CreateHomeCamCompleteScreen(),
          ),
        );
      } else {
        if (!mounted) return;
        showErrorDialog(context: context, message: '홈캠 등록에 실패했습니다.');
      }
    } on DioException catch (err) {
      print(err);
      final message = err.response?.data['message'] ?? '알 수 없는 오류가 발생했습니다.';
      if (!mounted) return;
      showErrorDialog(context: context, message: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '홈캠 등록',
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
        onSubmit: createHomeCam,
        navigateText: '등록 완료',
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
