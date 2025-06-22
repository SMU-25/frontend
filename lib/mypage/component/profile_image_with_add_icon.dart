import 'dart:io';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class ProfileImageWithAddIcon extends StatelessWidget {
  final File? image;
  final double profileIconSize;
  final double addImageIconSize;
  final double bottom;
  final double right;
  final double radius;
  final GestureTapCallback? onPressedChangePic;

  const ProfileImageWithAddIcon({
    required this.image,
    required this.profileIconSize,
    required this.addImageIconSize,
    required this.bottom,
    required this.right,
    required this.radius,
    required this.onPressedChangePic,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        image != null
            ? CircleAvatar(
          radius: radius,
          backgroundColor: Colors.white,
          backgroundImage: image != null ? FileImage(image!) : null,
        )
            : Icon(
          Icons.account_circle,
          size: profileIconSize,
          color: ICON_GREY_COLOR,
        ),
        Positioned(
          bottom: bottom,
          right: right,
          child: GestureDetector(
            onTap: onPressedChangePic,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_a_photo,
                size: addImageIconSize,
                color: ICON_GREY_COLOR,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
