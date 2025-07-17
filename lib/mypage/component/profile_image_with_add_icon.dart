import 'dart:io';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class ProfileImageWithAddIcon extends StatelessWidget {
  final File? image;
  final String? networkImageUrl;
  final double profileIconSize;
  final double addImageIconSize;
  final double bottom;
  final double right;
  final double radius;
  final GestureTapCallback? onPressedChangePic;
  final bool showAddIcon;

  const ProfileImageWithAddIcon({
    required this.image,
    required this.networkImageUrl,
    required this.profileIconSize,
    required this.addImageIconSize,
    required this.bottom,
    required this.right,
    required this.radius,
    required this.onPressedChangePic,
    this.showAddIcon = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (image != null) {
      imageWidget = CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        backgroundImage: FileImage(image!),
      );
    } else if (networkImageUrl != null && networkImageUrl!.isNotEmpty) {
      imageWidget = CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(networkImageUrl!),
      );
    } else {
      imageWidget = Icon(
        Icons.account_circle,
        size: profileIconSize,
        color: ICON_GREY_COLOR,
      );
    }

    return Stack(
      children: [
        imageWidget,
        if(showAddIcon)
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
          )
      ],
    );
  }
}
