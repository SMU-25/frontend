import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class EmailInput extends StatefulWidget {
  final TextEditingController emailIdController;
  final TextEditingController emailDomainController;
  final String? customEmailDomain;
  final ValueChanged<String>? onCustomEmailDomainChanged;
  final bool isReadOnly;

  const EmailInput({
    super.key,
    required this.emailIdController,
    required this.emailDomainController,
    this.customEmailDomain,
    this.onCustomEmailDomainChanged,
    this.isReadOnly = false,
  });

  @override
  State<EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  final List<String> emailDomains = ['gmail.com', 'naver.com', '직접입력'];
  late String selectedDomain;
  late TextEditingController customDomainController;

  @override
  void initState() {
    super.initState();

    final currentDomain = widget.emailDomainController.text;
    if (currentDomain == 'gmail.com' || currentDomain == 'naver.com') {
      selectedDomain = currentDomain;
    } else {
      selectedDomain = '직접입력';
    }

    customDomainController = TextEditingController(
      text: widget.customEmailDomain ?? (selectedDomain == '직접입력' ? currentDomain : ''),
    );
  }

  @override
  void didUpdateWidget(covariant EmailInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.customEmailDomain != oldWidget.customEmailDomain) {
      customDomainController.text = widget.customEmailDomain ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              '이메일',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
        Row(
          children: [
            // 이메일 앞부분
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 60,
                child: TextFormField(
                  controller: widget.emailIdController,
                  enabled: !widget.isReadOnly,
                  decoration: InputDecoration(
                    filled: widget.isReadOnly,
                    fillColor: widget.isReadOnly ? Colors.grey[200] : null,
                    hintText: '이메일',
                    hintStyle: TextStyle(color: INPUT_BORDER_COLOR),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: ICON_GREY_COLOR, width: 1.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Text('@', style: TextStyle(fontSize: 16)),
            SizedBox(width: 8),

            // 이메일 도메인
            Expanded(
              flex: 2,
              child: selectedDomain == '직접입력'
                  ? SizedBox(
                height: 60,
                child: TextFormField(
                  controller: customDomainController,
                  enabled: !widget.isReadOnly,
                  onChanged: (value) {
                    widget.onCustomEmailDomainChanged?.call(value);
                  },
                  decoration: InputDecoration(
                    filled: widget.isReadOnly,
                    fillColor: widget.isReadOnly ? Colors.grey[200] : null,
                    hintText: '직접 입력',
                    hintStyle: TextStyle(color: INPUT_BORDER_COLOR),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: MAIN_COLOR, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: ICON_GREY_COLOR, width: 1.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                ),
              )
                  :
              SizedBox(
                height: 60,
                child: IgnorePointer(
                  ignoring: widget.isReadOnly,
                  child: DropdownButtonFormField<String>(
                    value: selectedDomain,
                    items: emailDomains.map((domain) {
                      return DropdownMenuItem(
                        value: domain,
                        child: Text(domain),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDomain = value!;
                        if (value != '직접입력') {
                          widget.emailDomainController.text = value;
                          widget.onCustomEmailDomainChanged?.call('');
                          customDomainController.clear();
                        } else {
                          widget.emailDomainController.clear();
                          customDomainController.text = widget.customEmailDomain ?? '';
                          widget.onCustomEmailDomainChanged?.call(customDomainController.text);
                        }
                      });
                    },
                    decoration: InputDecoration(
                      filled: widget.isReadOnly,
                      fillColor: widget.isReadOnly ? Colors.grey[200] : null,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: MAIN_COLOR, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: ICON_GREY_COLOR, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
