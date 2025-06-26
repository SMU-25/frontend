import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/report/view/symptom_summary_dialog.dart';
import 'package:team_project_front/settings/component/custom_appbar.dart';

class CreateReport extends StatefulWidget {
  const CreateReport({super.key});

  @override
  State<CreateReport> createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController etcController = TextEditingController();
  final TextEditingController outingController = TextEditingController();

  final List<String> allSymptoms = [
    '발열', '구토', '경련', '코피', '설사',
    '피부 발진', '실신', '호흡곤란', '기침', '콧물', '황달'
  ];

  final List<String> frequentSymptoms = [
    '발열', '구토', '경련', '코피', '설사',
    '피부 발진', '호흡곤란', '기침', '콧물'
  ];

  final Set<String> selectedSymptoms = {};

  bool get isFormValid {
    return selectedSymptoms.isNotEmpty ||
      etcController.text.trim().isNotEmpty ||
      outingController.text.trim().isNotEmpty;
  }

  void onNextPressed() {
    showDialog(
      context: context,
      builder: (context) => SymptomSummaryDialog(
        selectedSymptoms: selectedSymptoms,
        etcSymptom: etcController.text,
        outingRecord: outingController.text,
        allSymptoms: allSymptoms
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: CustomAppbar(
          title: '리포트 생성',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Form(
          key: _formKey,
          onChanged: () => setState(() {}),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '아이의 현재 증상을 선택해주세요',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              SizedBox(height: 20),
              Text(
                '자주 일어나는 증상',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              SizedBox(height: 15),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: frequentSymptoms.map((symptom) {
                  final isSelected = selectedSymptoms.contains(symptom);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected
                          ? selectedSymptoms.remove(symptom)
                          : selectedSymptoms.add(symptom);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                          ? MAIN_COLOR
                          : MAIN_COLOR.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        symptom,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
              Text('전체 증상',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: allSymptoms.length,
                itemBuilder: (context, index) {
                  final symptom = allSymptoms[index];
                  final isSelected = selectedSymptoms.contains(symptom);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected
                          ? selectedSymptoms.remove(symptom)
                          : selectedSymptoms.add(symptom);
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                      decoration: BoxDecoration(
                        color: isSelected
                          ? MAIN_COLOR.withValues(alpha: 0.18)
                          : Colors.white,
                        border: Border.all(
                          color: isSelected ? MAIN_COLOR : Colors.black12,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'asset/img/symptoms/$index.png',
                            width: 32,
                            height: 32,
                          ),
                          SizedBox(width: 16),
                          Text(
                            symptom,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Text(
                '기타 증상',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: etcController,
                decoration: InputDecoration(
                  hintText: '기타 추가 증상을 입력해주세요',
                  hintStyle: TextStyle(color: INPUT_BORDER_COLOR, fontWeight: FontWeight.w500),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: MAIN_COLOR, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: MAIN_COLOR.withValues(alpha: 0.5), width: 4),
                  )
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    '외출 기록',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)
                  ),
                  SizedBox(width: 5),
                  Text(
                    '최근 발열',
                    style: TextStyle(color: HIGH_FEVER_COLOR, fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                  Text(
                    '(2025/04/09 14:22)',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                  )
                ],
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: outingController,
                decoration: InputDecoration(
                    hintText: '가장 최근 외출 기록을 자세히 입력해주세요',
                    hintStyle: TextStyle(color: INPUT_BORDER_COLOR, fontWeight: FontWeight.w500),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: MAIN_COLOR, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: MAIN_COLOR.withValues(alpha: 0.5), width: 4),
                    )
                ),
              ),
              SizedBox(height: 10),
              Text(
                'ex) 2025년 4월 9일 오후 1시~3시 잠실 호수 공원',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: NavigationButton(
          text: '다음',
          onPressed: isFormValid ? onNextPressed : null,
        ),
      ),
    );
  }
}
