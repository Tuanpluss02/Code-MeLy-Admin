import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mely_admin/controllers/image_picker.dart';
import 'package:mely_admin/controllers/loading_control.dart';
import 'package:mely_admin/models/chip_filter.dart';
import 'package:mely_admin/models/user.dart';
import 'package:mely_admin/services/auth.dart';
import 'package:mely_admin/styles/app_styles.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final imageController = Get.find<ImageController>();
  final loadController = Get.find<LoadingControl>();
  UserInformation user = UserInformation(
      userId: '',
      displayName: 'Code MeLy',
      email: 'contact@codemely.dart',
      team: 'Techincal',
      dateOfBirth: '01/01/2000',
      profilePicture: '',
      about: 'A member of Code MeLy',
      role: 'Member');
  final _formKey = GlobalKey<FormState>();
  RxString dateOfBirth = ''.obs;
  String password = 'Codemely@123';

  @override
  void initState() {
    super.initState();
    user.joinedAt =
        '${DateTime.now()}'.split(' ')[0].split('-').reversed.join('/');
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
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    maxLines: 5,
                    minLines: 3,
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
                      selected: 0, // Select the second filter as default
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
                      selected: 0, // Select the second filter as default
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
                    child: Obx(() => loadController.loading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            // margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: Get.width,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  AuthClass().registerUser(
                                      user,
                                      password,
                                      imageController,
                                      loadController,
                                      context,
                                      () => showSnackBar(
                                          context, 'User added successfully'));
                                } else {
                                  showSnackBar(
                                      context, 'Please fill all fields');
                                }
                              },
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