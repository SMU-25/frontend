import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class ProfileGenderSelector extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String> onGenderSelected;

  const ProfileGenderSelector({
    super.key,
    required this.selectedGender,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> genders = ['여자', '남자'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '성별',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (int i = 0; i < genders.length; i++) ...[
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () => onGenderSelected(genders[i]),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedGender == genders[i]
                          ? MAIN_COLOR.withAlpha(33)
                          : Theme.of(context).scaffoldBackgroundColor,
                      foregroundColor: selectedGender == genders[i]
                          ? MAIN_COLOR
                          : Colors.black54,
                      side: BorderSide(
                        color: selectedGender == genders[i]
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
                      genders[i],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              if (i != genders.length - 1) const SizedBox(width: 16),
            ]
          ],
        ),
      ],
    );
  }
}
