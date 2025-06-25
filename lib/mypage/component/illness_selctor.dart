import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class IllnessSelector extends StatelessWidget {
  final List<String> illnesses;
  final Set<String> selectedIllnesses;
  final ValueChanged<Set<String>> onSelectionChanged;

  const IllnessSelector({
    super.key,
    required this.illnesses,
    required this.selectedIllnesses,
    required this.onSelectionChanged,
  });

  String getDisplayText(String illness) {
    return illness == '면역력 저하' ? '면역력\n저하' : illness;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '진단받은 질환',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 15),
        LayoutBuilder(
          builder: (context, constraints) {
            final buttonWidth = (constraints.maxWidth - 20) / 3;

            return Wrap(
              spacing: 10,
              runSpacing: 15,
              children: illnesses.map((illness) {
                final isSelected = selectedIllnesses.contains(illness);
                final isFullWidth = illness == '해당 없음';

                return SizedBox(
                  width: isFullWidth ? constraints.maxWidth : buttonWidth,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      final updated = Set<String>.from(selectedIllnesses);
                      if (illness == '해당 없음') {
                        updated
                          ..clear()
                          ..add('해당 없음');
                      } else {
                        updated.remove('해당 없음');
                        isSelected ? updated.remove(illness) : updated.add(illness);
                      }
                      onSelectionChanged(updated);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? MAIN_COLOR.withOpacity(0.13)
                          : Theme.of(context).scaffoldBackgroundColor,
                      foregroundColor: isSelected ? MAIN_COLOR : Colors.black54,
                      side: BorderSide(
                        color: isSelected ? MAIN_COLOR : ICON_GREY_COLOR,
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
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
