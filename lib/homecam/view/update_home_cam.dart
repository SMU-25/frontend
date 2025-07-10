import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/custom_navigation_bar.dart';
import 'package:team_project_front/common/view/root_tab.dart';
import 'package:team_project_front/homecam/component/home_cam_form.dart';
import 'package:team_project_front/homecam/view/create_home_cam_complete.dart';

class UpdateHomeCamScreen extends StatefulWidget {
  const UpdateHomeCamScreen({super.key});

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
  final List<String> children = ['준형', '지환', '강민'];

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

  void onSubmit() {
    if (formKey.currentState!.validate() && selectedChild != null) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => CreateHomeCamCompleteScreen()));
    } else if (selectedChild == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('아이를 선택해주세요')));
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
        onSubmit: onSubmit,
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
