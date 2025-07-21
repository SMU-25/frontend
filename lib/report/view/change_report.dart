import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/utils/secure_storage_service.dart';
import 'package:team_project_front/report/component/custom_text_input.dart';
import 'package:team_project_front/report/model/report_info.dart';
import 'package:team_project_front/report/view/create_report.dart';
import 'package:team_project_front/settings/component/custom_appbar.dart';

class ChangeReport extends StatefulWidget {
  final ReportInfo report;

  const ChangeReport({
    super.key,
    required this.report,
  });

  @override
  State<ChangeReport> createState() => _ChangeReportState();
}

class _ChangeReportState extends State<ChangeReport> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController etcController;
  late TextEditingController outingController;
  final Set<String> selectedSymptoms = {};

  final List<String> allSymptoms = [
    '발열', '구토', '경련', '코피', '설사',
    '피부 발진', '실신', '호흡 곤란', '기침', '콧물', '황달'
  ];

  final List<String> frequentSymptoms = [
    '발열', '구토', '경련', '코피', '설사',
    '피부 발진', '호흡 곤란', '기침', '콧물'
  ];

  String? accessToken;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    final token = await SecureStorageService.getAccessToken();

    if (token == null) {
      print('accessToken 없음! 로그인 필요');
      return;
    }

    setState(() {
      accessToken = 'Bearer $token';
      etcController = TextEditingController(text: widget.report.etcSymptom);
      outingController = TextEditingController(text: widget.report.outingRecord);
      selectedSymptoms.addAll(widget.report.symptoms);
    });
  }

  bool get isFormValid {
    return selectedSymptoms.isNotEmpty ||
        etcController.text.trim().isNotEmpty ||
        outingController.text.trim().isNotEmpty;
  }

  void onSavePressed() async {
    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인이 필요합니다')),
      );
      return;
    }

    try {
      final dio = Dio();

      final convertedSymptoms = selectedSymptoms
          .map((s) => s.replaceAll(' ', '_'))
          .toList();

      final response = await dio.patch(
        '$base_URL/reports/${widget.report.reportId}',
        data: {
          'symptoms': convertedSymptoms,
          'etc_symptom': etcController.text.trim(),
          'outing': outingController.text.trim(),
        },
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final resData = response.data;

      if (response.statusCode == 200 && resData['isSuccess'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('리포트 수정이 완료되었습니다')),
        );
        Navigator.of(context).pop(true);
      } else {
        if (resData['code'] == 'FEVER_RECORD404') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('홈캠을 통한 체온, 온습도 정보가 존재해야 합니다')),
          );
          Navigator.of(context).pushNamed('/home');
          return;
        }

        throw Exception('수정 실패: ${resData['message']}');
      }
    } catch(e) {
      print('예외 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('리포트 수정 중 오류가 발생했어요')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (accessToken == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: CustomAppbar(title: '리포트 수정'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Form(
          key: _formKey,
          onChanged: () => setState(() {}),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('아이의 현재 증상을 선택해주세요',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              SizedBox(height: 20),
              FrequentSymptomsWidget(
                symptoms: frequentSymptoms,
                selectedSymptoms: selectedSymptoms,
                onTap: _onSymptomTapped,
              ),
              SizedBox(height: 30),
              AllSymptomsWidget(
                symptoms: allSymptoms,
                selectedSymptoms: selectedSymptoms,
                onTap: _onSymptomTapped,
              ),
              SizedBox(height: 20),
              Text('기타 증상',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              SizedBox(height: 15),
              CustomTextFormField(
                controller: etcController,
                hintText: '기타 추가 증상을 입력해주세요',
              ),
              SizedBox(height: 20),
              Text('외출 기록',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              SizedBox(height: 15),
              CustomTextFormField(
                controller: outingController,
                hintText: '가장 최근 외출 기록을 자세히 입력해주세요',
              ),
              SizedBox(height: 10),
              Text('ex) 2025년 4월 9일 오후 1시~3시 잠실 호수 공원',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: NavigationButton(
          text: '수정 완료',
          onPressed: isFormValid ? onSavePressed : null,
        ),
      ),
    );
  }

  void _onSymptomTapped(String symptom) {
    setState(() {
      if (selectedSymptoms.contains(symptom)) {
        selectedSymptoms.remove(symptom);
      } else {
        selectedSymptoms.add(symptom);
      }
    });
  }
}
