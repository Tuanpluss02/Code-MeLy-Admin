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

  void removeImage() {
    image = null;
    update();
  }

  /// It takes a path to an image file in the assets folder, loads it into memory, converts it to a base64
  /// string, and returns the base64 string
  ///
  /// Args:
  ///   path (String): The path to the image file in the assets folder.
  ///
  /// Returns:
  ///   A base64 encoded string of the image.
  Future<String> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);
    Uint8List fileByte = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    String basestring = base64.encode(fileByte);
    return basestring;
  }

  /// It takes an image, uploads it to firebase storage, and returns the download url
  ///
  /// Args:
  ///   id (String): The id of the user.
  ///   defaultImagePath (String): This is the path to the default image in the assets folder.
  ///   destination (String): The folder in the Firebase Storage where the image will be stored.
  ///
  /// Returns:
  ///   A Future<String>
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
