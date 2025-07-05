import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class InputWithTextButton extends StatelessWidget {
  const InputWithTextButton({
    super.key,
    required this.controller,
    required this.hintText,
    required this.buttonText,
    required this.onPressed,
    this.prefixIcon,
    this.validator,
    this.contentPadding,
  });

  final TextEditingController controller;
  final String hintText;
  final String buttonText;
  final VoidCallback onPressed;
  final Icon? prefixIcon;
  final FormFieldValidator<String>? validator;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 210,
              child: TextFormField(
                controller: controller,
                onChanged: (_) => (context as Element).markNeedsBuild(),
                validator: validator,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding:
                      contentPadding ?? EdgeInsets.symmetric(vertical: 23),
                  prefixIcon: prefixIcon,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 2.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: MAIN_COLOR, width: 2.2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.red, width: 2.2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.red, width: 2.2),
                  ),
                  errorStyle: TextStyle(fontSize: 11),
                ),
              ),
            ),
            SizedBox(width: 10),

            Padding(
              padding: const EdgeInsets.only(top: 7.0),
              child: TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 15,
                  ),
                  backgroundColor: MAIN_COLOR,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
