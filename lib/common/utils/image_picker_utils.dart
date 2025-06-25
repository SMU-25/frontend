import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImageFromGallery() async {
  final ImagePicker picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if(pickedFile != null) {
    return File(pickedFile.path);
  } else {
    return null;
  }
}