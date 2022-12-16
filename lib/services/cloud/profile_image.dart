import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ProfileImage {
  Future<File> profileImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    File img = File(image!.path);
    return img;
  }
}
