// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mely_admin/controllers/image_picker.dart';
import 'package:mely_admin/controllers/loading_control.dart';
import 'package:mely_admin/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthClass {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signOut(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await _auth.signOut();
      await prefs.clear();
      const snackBar = SnackBar(content: Text('Signed out successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  bool emailValidator(String email) {
    RegExp exp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return exp.hasMatch(email);
  }

  bool passwordValidator(String password) {
    RegExp exp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
    return exp.hasMatch(password);
  }

  bool oldPasswordValidator(String oldPassword) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final credential = EmailAuthProvider.credential(
        email: currentUser.email!, password: oldPassword);
    try {
      currentUser.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return false;
      }
    }
    return true;
  }

  changeEmail(String email, BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    try {
      await currentUser.updateEmail(email);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .collection('UserInformation')
          .doc(currentUser.uid)
          .set({
        'email': email,
      }, SetOptions(merge: true));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      showSnackBar(context, 'Email changed successfully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'The account already exists for that email');
      }
    }
  }

  changeDisplayName(String displayName, BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .collection('UserInformation')
          .doc(currentUser.uid)
          .set({
        'displayName': displayName,
      }, SetOptions(merge: true)).then((p) {
        // currentUser.displayName = displayName;
        // saveDataToLocal(currentUser);
      });
    } on FirebaseAuthException {
      showSnackBar(context, 'Failed to change display name');
    }
    showSnackBar(context, 'Display name changed successfully');
  }

  Future<void> changePassword(
      String newPassword, String currentPassword, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser!;
    try {
      final cred = EmailAuthProvider.credential(
          email: user.email!, password: currentPassword);
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      showSnackBar(context, 'Password changed successfully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        showSnackBar(context, 'Failed to change password');
      }
    }
  }

  Future<UserInformation> changeDisplayPicture(
      BuildContext context, UserInformation user) async {
    final picker = ImagePicker();
    try {
      final image =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
      Reference ref = FirebaseStorage.instance.ref().child('user_image');
      ref.child('${user.userId}.jpg').delete();
      ref = ref.child('${user.userId}.jpg');
      UploadTask uploadTask = ref.putFile(File(image!.path));
      final snapshot = await uploadTask.whenComplete(() => null);
      user.profilePicture = await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.userId)
          .set({
        'profilePicture': user.profilePicture,
      }, SetOptions(merge: true));
      showSnackBar(context, 'Profile picture changed successfully');
      return user;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return user;
  }

  Future<String> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    Uint8List fileByte = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    String basestring = base64.encode(fileByte);
    return basestring;
  }

  Future<void> registerUser(
      UserInformation user,
      String password,
      ImageController imageController,
      LoadingControl loadingControl,
      BuildContext context,
      VoidCallback showBar) async {
    late UserCredential userCredential;
    loadingControl.loading = true;
    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email!,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, 'The password provided is too weak.');
        return;
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'The account already exists for that email.');
        return;
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return;
    }

    user.userId = userCredential.user!.uid;

    Reference ref = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child('${userCredential.user!.uid}.jpg');

    UploadTask uploadTask;
    if (imageController.image != null) {
      uploadTask = ref.putFile(imageController.image!);
    } else {
      uploadTask = ref.putString(
          await getImageFileFromAssets('images/defaultAvatar.jpg'),
          format: PutStringFormat.base64);
    }
    final snapshot = await uploadTask.whenComplete(() => null);
    user.profilePicture = await snapshot.ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userCredential.user!.uid)
        .set({
      'userId': user.userId,
      'displayName': user.displayName,
      'email': user.email,
      'team': user.team,
      'role': user.role,
      'dateOfBirth': user.dateOfBirth,
      'joinedAt': user.joinedAt,
      'profilePicture': user.profilePicture,
      'about': user.about,
    });
    loadingControl.loading = false;
    showBar.call();
  }

  Future<void> updateUserInformation(UserInformation user,
      LoadingControl loadingControl, BuildContext context) async {
    loadingControl.loading = true;
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.userId)
          .set({
        'userId': user.userId,
        'displayName': user.displayName,
        'email': user.email,
        'team': user.team,
        'role': user.role,
        'dateOfBirth': user.dateOfBirth,
        'joinedAt': user.joinedAt,
        'profilePicture': user.profilePicture,
        'about': user.about,
      });
      loadingControl.loading = false;
      showSnackBar(context, 'User information updated successfully');
    } catch (e) {
      showSnackBar(context, 'Failed to update user information');
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
