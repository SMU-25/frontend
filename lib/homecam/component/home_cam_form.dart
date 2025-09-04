import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/component/custom_input.dart';
import 'package:team_project_front/common/component/navigation_button.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/model/baby.dart';
import 'package:team_project_front/common/utils/error_dialog.dart';
import 'package:team_project_front/common/utils/secure_storage_service.dart';
import 'package:team_project_front/mypage/view/add_profile_screen.dart';

class HomeCamForm extends StatefulWidget {
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
  State<HomeCamForm> createState() => _HomeCamFormState();
}

class _HomeCamFormState extends State<HomeCamForm> {
  List<Baby> babies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBabies();
  }

  // 추후 캐싱 이용하면 좋을듯
  Future<void> fetchBabies() async {
    try {
      final dio = Dio();
      final token = await SecureStorageService.getAccessToken();

      final res = await dio.get(
        '$base_URL/children',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (res.statusCode == 200) {
        final data = List<Map<String, dynamic>>.from(res.data['result']);
        final loadedBabies =
            data
                .map((baby) {
                  final id = (baby['childId'] as num?)?.toInt();
                  final name = baby['name'] as String? ?? '이름없음';
                  final profile = baby['profileImage'] as String? ?? '';

                  if (id == null) {
                    return null;
                  }

                  return Baby.forList(
                    childId: id,
                    name: name,
                    profileImage: profile,
                  );
                })
                .whereType<Baby>()
                .toList();

        if (!mounted) return;
        setState(() {
          babies = loadedBabies;
          isLoading = false;
        });
      } else {
        if (!mounted) return;
        showErrorDialog(context: context, message: '아이들 불러오기에 실패했습니다.');
      }
    } on DioException catch (err) {
      final message = err.response?.data['message'] ?? '알 수 없는 오류가 발생했습니다.';
      if (!mounted) return;
      showErrorDialog(context: context, message: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: widget.formKey,
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
                controller: widget.nameController,
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
                controller: widget.installationPlaceController,
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
              (babies.isEmpty)
                  ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400, width: 2),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.child_care),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('등록된 아이가 없어요')),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddProfileScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('아이 등록'),
                        ),
                      ],
                    ),
                  )
                  : Container(
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
                          value: widget.selectedChild,
                          isExpanded: true,
                          icon: Icon(Icons.expand_more, size: 40),
                          items:
                              babies
                                  .map(
                                    (baby) => DropdownMenuItem(
                                      value: baby.childId.toString(),
                                      child: Text(baby.name),
                                    ),
                                  )
                                  .toList(),
                          onChanged: widget.onChildChanged,
                        ),
                      ),
                    ),
                  ),
              const SizedBox(height: 20),
              _buildLabel('홈캠 번호'),
              CustomTextFormField(
                controller: widget.serialNumController,
                hintText: '홈캠 번호 ( 예:ABC123 )',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '홈캠 번호를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              NavigationButton(
                text: widget.navigateText,
                onPressed: widget.onSubmit,
              ),
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
