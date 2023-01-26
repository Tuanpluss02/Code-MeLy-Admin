import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mely_admin/models/chip_filter.dart';
import 'package:mely_admin/models/user.dart';
import 'package:mely_admin/styles/app_styles.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final imageController = Get.find<ImageController>();
  UserInformation user = UserInformation();
  RxBool isLoading = false.obs;
  final _formKey = GlobalKey<FormState>();
  RxString dateOfBirth = ''.obs;
  String password = 'Codemely@123';

  Future<String> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    Uint8List fileByte = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    String basestring = base64.encode(fileByte);
    return basestring;
  }

  Future<void> registerUser(VoidCallback showBar) async {
    late UserCredential userCredential;
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    isLoading.value = true;

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
    isLoading.value = false;
    showBar.call();
  }

  @override
  void initState() {
    super.initState();
    user.joinedAt =
        '${DateTime.now()}'.split(' ')[0].split('-').reversed.join('/');
    user.about = 'A member of Code MeLy';
    user.role = 'Member';
  }

  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Column(
                      children: [
                        GetBuilder<ImageController>(
                          builder: (_) {
                            return ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(80), // Image radius
                                child: imageController.image != null
                                    ? Image.file(imageController.image!)
                                    : Image.asset(
                                        'assets/images/defaultAvatar.jpg',
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
                      ],
                    ),
                  ),
                  // const SizedBox(width: 15),
                  Row(
                    children: [
                      // const SizedBox(height: 10),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.black45),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            labelText: 'Full name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter full name';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            user.displayName = newValue;
                          },
                          // onChanged: (value) {
                          //   user.fullName = value;
                          // },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: Colors.black45,
                              ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            labelText: 'Date of birth',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter date of birth';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            user.dateOfBirth = newValue;
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
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.black45),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            user.email = newValue;
                          },
                          // onChanged: (value) {
                          //   user.email = value;
                          // },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: Colors.black45),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          password = newValue!;
                        },
                      ))
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black45),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      labelText: 'Join date: ${user.joinedAt}',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    onSaved: (newValue) {
                      if (newValue != null && newValue.isNotEmpty) {
                        user.joinedAt = newValue;
                      }
                    },
                    // onChanged: (value) {
                    //   user.phoneNumber = value;
                    // },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black45),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      labelText: 'About ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    onSaved: (newValue) {
                      user.about = newValue;
                    },
                    // onChanged: (value) {
                    //   user.phoneNumber = value;
                    // },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Choose team: ',
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    height: 40,
                    child: ChipsFilter(
                      selected: 1, // Select the second filter as default
                      filters: const [
                        Filter(label: "Technical", icon: Icons.military_tech),
                        Filter(label: "Communication", icon: Icons.people),
                        Filter(label: "Security", icon: Icons.security),
                        Filter(label: "Algorithm", icon: Icons.safety_check),
                      ],
                      onTap: () {
                        user.team = getSelectedFilter();
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Choose role: ',
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    height: 40,
                    child: ChipsFilter(
                      selected: 1, // Select the second filter as default
                      filters: const [
                        Filter(
                            label: "Founder",
                            icon: Icons.person_outline_outlined),
                        Filter(label: "Co-Founder", icon: Icons.person_outline),
                        Filter(label: "Leader", icon: Icons.person_outline),
                        Filter(label: "Member", icon: Icons.person_outline),
                      ],
                      onTap: () {
                        user.role = getSelectedFilter();
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Obx(() => isLoading.value
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            // margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: Get.width,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () => registerUser(() => showSnackBar(
                                  context, 'User added successfully')),
                              style: ElevatedButton.styleFrom(
                                // padding: EdgeInsets.symmetric(horizontal: Get.width),
                                backgroundColor: Colors.deepPurpleAccent,
                                shape: const StadiumBorder(),
                              ),
                              child: const Text(
                                "Register new member",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          )),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class ImageController extends GetxController {
  static ImageController get to => Get.find();
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