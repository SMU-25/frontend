import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/custom_checkbox.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/signup/view/signup_email.dart';

class SignupAgreementScreen extends StatefulWidget {
  const SignupAgreementScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _SignupAgreementScreenState();
  }
}

class _SignupAgreementScreenState extends State<SignupAgreementScreen> {
  bool allAgreed = false;
  bool ageAgreed = false;
  bool personalInfoAgreed = false;
  bool sensitiveInfoAgreed = false;
  bool locationAgreed = false;
  bool adAgreed = false;

  void toggleAll(bool? value) {
    setState(() {
      allAgreed = value!;
      ageAgreed = value;
      personalInfoAgreed = value;
      sensitiveInfoAgreed = value;
      locationAgreed = value;
      adAgreed = value;
    });
  }

  bool _isAgreementValid() {
    return ageAgreed &&
        personalInfoAgreed &&
        sensitiveInfoAgreed &&
        locationAgreed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '맘편해 서비스 이용약관에\n동의해주세요',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 25),
            CustomCheckbox(
              text: '전체 동의',
              size: 20,
              value: allAgreed,
              onChanged: toggleAll,
              showArrow: false,
            ),
            SizedBox(height: 15),
            Divider(),
            SizedBox(height: 15),
            CustomCheckbox(
              text: '[필수] 만 14세 이상입니다.',
              size: 15,
              value: ageAgreed,
              onChanged: (val) => setState(() => ageAgreed = val!),
              showArrow: false,
            ),
            SizedBox(height: 15),
            CustomCheckbox(
              text: '[필수] 개인정보 수집 및 이용동의',
              size: 15,
              value: personalInfoAgreed,
              onChanged: (val) => setState(() => personalInfoAgreed = val!),
              showArrow: true,
            ),
            SizedBox(height: 15),
            CustomCheckbox(
              text: '[필수] 민감정보 수집 및 이용동의',
              size: 15,
              value: sensitiveInfoAgreed,
              onChanged: (val) => setState(() => sensitiveInfoAgreed = val!),
              showArrow: true,
            ),
            SizedBox(height: 15),
            CustomCheckbox(
              text: '[필수] 위치기반 서비스 이용약관',
              size: 15,
              value: locationAgreed,
              onChanged: (val) => setState(() => locationAgreed = val!),
              showArrow: true,
            ),
            SizedBox(height: 15),
            CustomCheckbox(
              text: '[선택] 광고성 수신 동의',
              size: 15,
              value: adAgreed,
              onChanged: (val) => setState(() => adAgreed = val!),
              showArrow: true,
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: NavigationButton(
            text: '다음',
            onPressed: () {
              if (_isAgreementValid()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SignupEmailScreen()),
                );
              } else {
                // snackBar로 필수항목 동의 메시지 처리함
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('필수 항목에 모두 동의해주세요.')));
              }
            },
          ),
        ),
      ),
    );
  }
}
