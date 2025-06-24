import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/complete_dialog.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/common/view/root_tab.dart';
import 'package:team_project_front/mypage/component/illness_selctor.dart';
import 'package:team_project_front/mypage/component/seizure_history_selector.dart';
import 'package:team_project_front/mypage/models/profile_info.dart';
import 'package:team_project_front/settings/component/custom_appbar.dart';

class AddProfileSymptomsScreen extends StatefulWidget {
  final ProfileInfo profileInfo;

  const AddProfileSymptomsScreen({
    required this.profileInfo,
    super.key,
  });

  @override
  State<AddProfileSymptomsScreen> createState() => _AddProfileSymptomsScreenState();
}

class _AddProfileSymptomsScreenState extends State<AddProfileSymptomsScreen> {

  String? seizure;
  Set<String> selectedIllness = {};

  final List<String> seizureOptions = ['있음', '없음', '모름'];
  final List<String> illnesses = [
    '해당 없음', '아토피', '천식', '뇌전증',
    '고혈압', '심장 질환', '폐 질환',
    '간 질환', '신장 질환', '면역력 저하',
  ];

  bool get isFormValid =>
    seizure != null &&
    selectedIllness.isNotEmpty;

  void onNextPressed() {
    if(!isFormValid) return;

    final updatedProfileInfo = widget.profileInfo.copyWith(
      seizureHistory: seizure!,
      illnessList: selectedIllness.toList(),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CompleteDialog(
        image: widget.profileInfo.image != null
          ? CircleAvatar(
            radius: 40,
            backgroundImage: FileImage(widget.profileInfo.image!),
          )
          : Icon(
              Icons.account_circle,
              size: 80,
              color: ICON_GREY_COLOR,
        ),
        title: "'${widget.profileInfo.name}' 등록 완료",
        content: "이제 아이를\n맘편해와 함께 돌봐주세요!",
        checkText: "완료",
        onPressedCheck: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => RootTab(initialTabIndex: 4)),
            (route) => false,
          );
        }
      ),
    );
  }
  
  String getDisplayText(String illness) {
    return illness == '면역력 저하' ? '면역력\n저하' : illness;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: CustomAppbar(
          title: '프로필 등록',
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '상세 정보를 알려주시면\n좀 더 정확히 알려드릴 수 있어요',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '상세 정보는 마이페이지에서 수정 및 입력이 가능해요',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),
              SeizureHistorySelector(
                selected: seizure,
                options: seizureOptions,
                onSelected: (val) => setState(() => seizure = val),
              ),
              SizedBox(height: 20),
              IllnessSelector(
                illnesses: illnesses,
                selectedIllnesses: selectedIllness,
                onSelectionChanged: (newSet) => setState(() => selectedIllness = newSet),
              ),
            ],
          )
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: NavigationButton(
          text: '저장',
          onPressed: isFormValid ? onNextPressed : null,
        ),
      )
    );
  }
}