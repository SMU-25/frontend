import 'dart:io';
import 'package:flutter/material.dart';
import 'package:team_project_front/common/utils/image_picker_utils.dart';

Future<void> handleImagePick({
  required BuildContext context,
  required void Function(File image) onImageSelected,
}) async {
  final selectedImage = await pickImageFromGallery();

  if (selectedImage != null) {
    onImageSelected(selectedImage);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('사진이 선택되지 않았습니다.')),
    );
  }
}
