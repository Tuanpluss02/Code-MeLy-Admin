import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mely_admin/controllers/image_picker.dart';
import 'package:mely_admin/controllers/loading_control.dart';
import 'package:mely_admin/models/chip_filter.dart';
import 'package:mely_admin/models/user.dart';
import 'package:mely_admin/services/auth.dart';
import 'package:mely_admin/styles/app_styles.dart';

Map<String, int> teams = {
  'Technical': 0,
  'Communication': 1,
  'Security': 2,
  'Agorithm': 3,
};

Map<String, int> roles = {
  'Founder': 0,
  'Co-Founder': 1,
  'Leader': 2,
  'Member': 3,
};

class EditUser extends StatefulWidget {
  final DocumentSnapshot docs;
  const EditUser({super.key, required this.docs});

  @override
  State<EditUser> createState() => _AddUserState();
}

class _AddUserState extends State<EditUser> {
  final imageController = Get.find<ImageController>();
  final loadController = Get.find<LoadingControl>();
  late UserInformation user;
  RxBool isChanged = false.obs;
  final _formKey = GlobalKey<FormState>();
  RxString dateOfBirth = ''.obs;
  // String password = 'Codemely@123';

  @override
  void initState() {
    user = UserInformation.fromJson(widget.docs.data() as Map<String, dynamic>);
    super.initState();
  }

  /// If the form is valid, save the form and update the user information
  void saveInfor() {
    if (isChanged.value) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        AuthClass().updateUserInformation(
          user,
          loadController,
          context,
        );
        isChanged.value = false;
      } else {
        showSnackBar(context, 'Please fill all fields');
      }
    }
  }

  /// If the user has made changes to the form, show a dialog asking if they want to save, discard, or
  /// cancel. If they choose to save, save the form. If they choose to discard, pop the dialog and the
  /// page. If they choose to cancel, just pop the dialog. If the user hasn't made changes to the form,
  /// just pop the page
  ///
  /// Returns:
  ///   A Future.value(false)
  Future<bool> _requestPop() {
    isChanged.value
        ? showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('You have unsaved changes.'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    Navigator.pop(context);
                  },
                  child: const Text('Discard'),
                ),
                TextButton(
                  onPressed: () {
                    saveInfor();
                    Navigator.pop(dialogContext);
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          )
        : Navigator.pop(context);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _requestPop(),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            title: Text(
              'Edit user',
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
                                  size: const Size.fromRadius(80),
                                  child: imageController.image != null
                                      ? Image.file(imageController.image!,
                                          fit: BoxFit.cover)
                                      : Image.asset(
                                          'assets/images/defaultAvatar.jpg',
                                          fit: BoxFit.cover),
                                ),
                              );
                            },
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              await imageController.getImage(context);
                              isChanged.value = true;
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
                            onChanged: (value) {
                              isChanged.value = true;
                            },
                            initialValue: widget.docs['displayName'],
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
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              isChanged.value = true;
                            },
                            initialValue: widget.docs['dateOfBirth'],
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
                    TextFormField(
                      onChanged: (value) {
                        isChanged.value = true;
                      },
                      initialValue: widget.docs['email'],
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black45),
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
                    ),

                    const SizedBox(height: 10),
                    TextFormField(
                      onChanged: (value) {
                        isChanged.value = true;
                      },
                      initialValue: widget.docs['joinedAt'],
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black45),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        labelText: 'Join date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      onSaved: (newValue) {
                        if (newValue != null && newValue.isNotEmpty) {
                          user.joinedAt = newValue;
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      onChanged: (value) {
                        isChanged.value = true;
                      },
                      maxLines: 5,
                      minLines: 3,
                      initialValue: widget.docs['about'],
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
                        selected: teams[widget.docs[
                            'team']]!, // Select the second filter as default
                        filters: const [
                          Filter(label: "Technical", icon: Icons.military_tech),
                          Filter(label: "Communication", icon: Icons.people),
                          Filter(label: "Security", icon: Icons.security),
                          Filter(label: "Algorithm", icon: Icons.safety_check),
                        ],
                        onTap: () {
                          isChanged.value = true;
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
                        selected: roles[widget.docs[
                            'role']]!, // Select the second filter as default
                        filters: const [
                          Filter(
                              label: "Founder",
                              icon: Icons.person_outline_outlined),
                          Filter(
                              label: "Co-Founder", icon: Icons.person_outline),
                          Filter(label: "Leader", icon: Icons.person_outline),
                          Filter(label: "Member", icon: Icons.person_outline),
                        ],
                        onTap: () {
                          isChanged.value = true;
                          user.role = getSelectedFilter();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                        child: Obx(() => !loadController.loading
                            ? SizedBox(
                                // margin: const EdgeInsets.symmetric(horizontal: 10),
                                width: Get.width,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    saveInfor();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    // padding: EdgeInsets.symmetric(horizontal: Get.width),
                                    backgroundColor: Colors.deepPurpleAccent,
                                    shape: const StadiumBorder(),
                                  ),
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              )
                            : const CircularProgressIndicator())),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

void showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
