import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class SeizureHistorySelector extends StatelessWidget {
  final String? selected;
  final List<String> options;
  final ValueChanged<String> onSelected;

  const SeizureHistorySelector({
    super.key,
    required this.selected,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '열성경련 이력',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            for (int i = 0; i < options.length; i++) ...[
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () => onSelected(options[i]),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selected == options[i]
                          ? MAIN_COLOR.withOpacity(0.13)
                          : Theme.of(context).scaffoldBackgroundColor,
                      foregroundColor: selected == options[i]
                          ? MAIN_COLOR
                          : Colors.black54,
                      side: BorderSide(
                        color: selected == options[i]
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
                      options[i],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              if (i != options.length - 1) const SizedBox(width: 12),
            ]
          ],
        ),
      ],
    );
  }
}
