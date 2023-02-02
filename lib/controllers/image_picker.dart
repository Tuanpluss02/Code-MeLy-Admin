import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mely_admin/utils/snack_bar.dart';

/// It's a class that has a property called image of type File? and a method called getImage that takes
/// a BuildContext as a parameter and returns a Future of type void
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

  Future<String> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    Uint8List fileByte = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    String basestring = base64.encode(fileByte);
    return basestring;
  }

  Future<String> getURL(
      String id, String defaultImagePath, String destination) async {
    Reference ref =
        FirebaseStorage.instance.ref().child(destination).child('$id.jpg');

    UploadTask uploadTask;
    if (image != null) {
      uploadTask = ref.putFile(image!);
    } else {
      uploadTask = ref.putString(await getImageFileFromAssets(defaultImagePath),
          format: PutStringFormat.base64);
    }
    final snapshot = await uploadTask.whenComplete(() => null);
    return await snapshot.ref.getDownloadURL();
  }
}
