import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/custom_input.dart';
import 'package:team_project_front/common/component/navigation_button.dart';

class HomeCamForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController installationPlaceController;
  final TextEditingController serialNumController;
  final String? selectedChild;
  final ValueChanged<String?> onChildChanged;
  final VoidCallback onSubmit;
  final String navigateText;

  const HomeCamForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.installationPlaceController,
    required this.serialNumController,
    required this.selectedChild,
    required this.onChildChanged,
    required this.onSubmit,
    required this.navigateText,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> children = ['준형', '지환', '강민'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '홈캠 정보를 입력해주세요',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              _buildLabel('홈캠 이름'),
              CustomTextFormField(
                controller: nameController,
                hintText: '이름 (2~8자)',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '홈캠 이름을 입력해주세요';
                  } else if (value.length < 2 || value.length > 8) {
                    return '2자 이상 8자 이하로 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildLabel('설치 장소'),
              CustomTextFormField(
                controller: installationPlaceController,
                hintText: '설치장소 (예: 안방, 거실)',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '설치 장소를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildLabel('아이'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 2),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: SizedBox(
                  height: 65,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: Text('선택'),
                      value: selectedChild,
                      isExpanded: true,
                      icon: Icon(Icons.expand_more, size: 40),
                      items:
                          children
                              .map(
                                (child) => DropdownMenuItem(
                                  value: child,
                                  child: Text(child),
                                ),
                              )
                              .toList(),
                      onChanged: onChildChanged,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildLabel('홈캠 번호'),
              CustomTextFormField(
                controller: serialNumController,
                hintText: '홈캠 번호 ( 예:ABC123 )',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '홈캠 번호를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              NavigationButton(text: navigateText, onPressed: onSubmit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: TextStyle(fontSize: 17)),
        const SizedBox(height: 10),
      ],
    );
  }
}
