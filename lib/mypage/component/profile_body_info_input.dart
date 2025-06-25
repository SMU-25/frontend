import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class ProfileBodyInfoInput extends StatelessWidget {
  final TextEditingController heightController;
  final TextEditingController weightController;
  final String? Function(String?)? validateHeight;
  final String? Function(String?)? validateWeight;

  const ProfileBodyInfoInput({
    super.key,
    required this.heightController,
    required this.weightController,
    this.validateHeight,
    this.validateWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildLabeledInput(
            label: '키',
            unit: 'cm',
            controller: heightController,
            validator: validateHeight,
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: _buildLabeledInput(
            label: '몸무게',
            unit: 'kg',
            controller: weightController,
            validator: validateWeight,
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledInput({
    required String label,
    required String unit,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        )),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                validator: validator,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '0.0',
                  hintStyle: const TextStyle(color: INPUT_BORDER_COLOR),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ICON_GREY_COLOR, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: MAIN_COLOR, width: 2.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(unit),
          ],
        ),
      ],
    );
  }
}