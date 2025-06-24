import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/complete_dialog.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/common/view/root_tab.dart';
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
              Text(
                '열성경련 이력',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  for (int i = 0; i < seizureOptions.length; i++) ...[
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () => setState(() {
                            seizure = seizureOptions[i];
                          }),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: seizure == seizureOptions[i]
                                ? MAIN_COLOR.withValues(alpha: 0.13)
                                : Theme.of(context).scaffoldBackgroundColor,
                            foregroundColor: seizure == seizureOptions[i]
                                ? MAIN_COLOR
                                : Colors.black54,
                            side: BorderSide(
                              color: seizure == seizureOptions[i]
                                  ? MAIN_COLOR
                                  : ICON_GREY_COLOR,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ).copyWith(
                            overlayColor: WidgetStateProperty.all(Colors.transparent),
                            splashFactory: NoSplash.splashFactory,
                            animationDuration: Duration.zero,
                            shadowColor: WidgetStateProperty.all(Colors.transparent),
                          ),
                          child: Text(
                            seizureOptions[i],
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    if (i != 2) SizedBox(width: 12), // 버튼 사이 간격
                  ]
                ],
              ),
              SizedBox(height: 20),
              Text(
                '진단받은 질환',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15),
              LayoutBuilder(
                builder: (context, constraints) {
                  final buttonWidth = (constraints.maxWidth - 20) / 3; // 한 줄 3개 + spacing 고려

                  return Wrap(
                    spacing: 10,
                    runSpacing: 15,
                    children: [
                      for (String illness in illnesses)
                        SizedBox(
                          width: illness == '해당 없음'
                              ? constraints.maxWidth // 전체 너비
                              : buttonWidth,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if(illness == '해당 없음') {
                                  selectedIllness = {'해당 없음'};
                                } else {
                                  selectedIllness.remove('해당 없음');
                                  if(selectedIllness.contains(illness)) {
                                    selectedIllness.remove(illness);
                                  } else {
                                    selectedIllness.add(illness);
                                  }
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedIllness.contains(illness)
                                  ? MAIN_COLOR.withValues(alpha: 0.13)
                                  : Theme.of(context).scaffoldBackgroundColor,
                              foregroundColor: selectedIllness.contains(illness)
                                  ? MAIN_COLOR
                                  : Colors.black54,
                              side: BorderSide(
                                color: selectedIllness.contains(illness)
                                    ? MAIN_COLOR
                                    : ICON_GREY_COLOR,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ).copyWith(
                              overlayColor: WidgetStateProperty.all(Colors.transparent),
                              splashFactory: NoSplash.splashFactory,
                              animationDuration: Duration.zero,
                              shadowColor: WidgetStateProperty.all(Colors.transparent),
                            ),
                            child: Text(
                              getDisplayText(illness),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                    ],
                  );
                },
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