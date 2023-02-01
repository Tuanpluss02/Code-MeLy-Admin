import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mely_admin/pages/users/add_user.dart';

class ImageController extends GetxController {
  static ImageController get to => Get.find();
  File? image;
  final picker = ImagePicker();
  Future<void> getImage(BuildContext context) async {
    try {
      final pickedFile = await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 100);

      if (pickedFile != null) {
        image = File(pickedFile.path);
      }
      update();
    } catch (e) {
      showSnackBar(context, 'Failed to pick image');
    }
  }
}
