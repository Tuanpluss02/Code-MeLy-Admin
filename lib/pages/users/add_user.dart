import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mely_admin/models/event.dart';
import 'package:mely_admin/styles/app_styles.dart';

enum Team { techical, commuication, security, boss }

enum Role { founder, cofounder, leader, member }

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  UserInformation user = UserInformation();
  var isLoading = false.obs;
  final _formKey = GlobalKey<FormState>();
  RxString dateOfBirth = ''.obs;
  RxString joinDate =
      '${DateTime.now()}'.split(' ')[0].split('-').reversed.join('/').obs;

  // Future<String> datePicker(bool hasTime) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1990),
  //     lastDate: DateTime(2050),
  //   );
  //   if (picked != null) {
  //     if (hasTime) {
  //       final TimeOfDay? time = await showTimePicker(
  //         context: context,
  //         initialTime: TimeOfDay.now(),
  //       );
  //       if (time != null) {
  //         return '${'${picked.toLocal()}'.split(' ')[0].split('-').reversed.join('/')} ${time.format(context)}';
  //         // return
  //       }
  //     }
  //     return '${picked.toLocal()}'.split(' ')[0].split('-').reversed.join('/');
  //   }
  //   return '';
  // }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<ImageController>(() => ImageController(), fenix: true);
    final imageController = Get.find<ImageController>();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            'Add user',
            style: AppStyle.title.copyWith(fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                GetBuilder<ImageController>(
                  builder: (_) {
                    return ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(80), // Image radius
                        child: imageController.image != null
                            ? Image.file(imageController.image!)
                            : Image.asset('assets/images/defaultAvatar.jpg',
                                fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
                TextButton.icon(
                  onPressed: () async {
                    await imageController.getImage();
                  },
                  icon: const Icon(Icons.image),
                  label: const Text('Pick Image'),
                ),
                // const SizedBox(width: 15),
                Row(
                  children: [
                    // const SizedBox(height: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Full name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                        // onChanged: (value) {
                        //   user.fullName = value;
                        // },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Date of birth',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your date of birth';
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        // onChanged: (value) {
                        //   user.email = value;
                        // },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ))
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Join date: $joinDate',
                    border: const OutlineInputBorder(),
                  ),

                  // onChanged: (value) {
                  //   user.phoneNumber = value;
                  // },
                )
              ],
            ),
          ),
        ));
  }
}

class ImageController extends GetxController {
  File? image;
  final picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    update();
  }
}

void showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
