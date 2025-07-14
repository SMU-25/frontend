import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/custom_input.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/model/user.dart';
import 'package:team_project_front/common/utils/error_dialog.dart';
import 'package:team_project_front/signup/component/gender_choicechip.dart';
import 'package:team_project_front/signup/utils/signup_complete.dart';

class SignupUserInfoScreen extends StatefulWidget {
  const SignupUserInfoScreen({
    super.key,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  State<StatefulWidget> createState() {
    return _SignupUserInfoState();
  }
}

class _SignupUserInfoState extends State<SignupUserInfoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  Gender? _selectedGender;
  DateTime? _birthDate;

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _birthDateController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate() && _selectedGender != null) {
      final user = User(
        name: _nameController.text,
        email: widget.email,
        password: widget.password,
        birthDate: _birthDate!,
        socialType: 'local',
        gender: _selectedGender!,
      );

      try {
        final dio = Dio();
        final response = await dio.post(
          '$base_URL/auth/signup',
          data: {
            'email': user.email,
            'password': user.password,
            'name': user.name,
            'birthDate': user.birthDate.toIso8601String().split('T').first,
            'gender': user.gender.name.toUpperCase(),
            'socialType': user.socialType.toUpperCase(),
          },
          options: Options(headers: {'Content-Type': 'application/json'}),
        );

        if (!mounted) return;

        if (response.statusCode == 200 && response.data['result'] == true) {
          await showSignupCompleteDialog(context);
        } else {
          showErrorDialog(context: context, message: '회원가입에 실패했습니다.');
        }
      } on DioException catch (err) {
        if (!mounted) return;
        String message = '알 수 없는 오류가 발생했습니다.';
        if (err.response?.data != null) {
          message = err.response?.data['message'] ?? message;
        }
        showErrorDialog(context: context, message: message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입', style: TextStyle(fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Text(
                  '회원 정보를 입력해주세요',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 20),
                const Text('이름/닉네임', style: TextStyle(fontSize: 17)),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _nameController,
                  hintText: '이름 또는 닉네임 입력 (2~8자)',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이름/닉네임을 입력해주세요';
                    } else if (value.length < 2 || value.length > 8) {
                      return '2자 이상 8자 이하로 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text('생년월일', style: TextStyle(fontSize: 17)),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _selectBirthDate,
                  // 터치 막기
                  child: AbsorbPointer(
                    child: CustomTextFormField(
                      controller: _birthDateController,
                      hintText: '생년월일 선택',
                      validator: (value) {
                        if (_birthDate == null) {
                          return '생년월일을 선택해주세요';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('성별', style: TextStyle(fontSize: 17)),
                const SizedBox(height: 20),

                Row(
                  children: [
                    GenderChoiceChip(
                      gender: Gender.female,
                      selectedGender: _selectedGender,
                      onSelected: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    GenderChoiceChip(
                      gender: Gender.male,
                      selectedGender: _selectedGender,
                      onSelected: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                  ],
                ),
                if (_selectedGender == null)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      '성별을 선택해주세요',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: NavigationButton(
            text: '다음',
            onPressed: () async {
              if (_formKey.currentState!.validate() &&
                  _selectedGender != null) {
                await _signUp();
                if (!mounted) return;
              }
            },
          ),
        ),
      ),
    );
  }
}
