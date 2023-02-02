import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:mely_admin/pages/users/edit_user.dart';
import 'package:mely_admin/services/auth.dart';
import 'package:mely_admin/services/firebase_name.dart';
import 'package:mely_admin/styles/app_styles.dart';
import 'package:mely_admin/utils/snack_bar.dart';
import 'package:mely_admin/widgets/fab_custom.dart';

class UserView extends StatefulWidget {
  final String userID;
  const UserView({super.key, required this.userID});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  /// A scroll controller that is used to control the visibility of the floating action button.
  late ScrollController _fabcontroller;

  /// A reactive variable that is used to control the visibility of the floating action button.
  late RxBool _isFabVisible;

  @override
  void initState() {
    super.initState();
    _fabcontroller = ScrollController();
    _isFabVisible = true.obs;
    _fabcontroller.addListener(() {
      if (_fabcontroller.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_isFabVisible.value == false) _isFabVisible.value = true;
      } else if (_fabcontroller.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isFabVisible.value == true) _isFabVisible.value = false;
      }
    });
  }

  /// This function is called when the user presses the delete button. It shows a dialog box asking the
  /// user if they are sure they want to delete the user. If they press cancel, the dialog box closes. If
  /// they press delete, the user is deleted from the database and the user is taken back to the previous
  /// page
  ///
  /// Args:
  ///   pop (VoidCallback): This is a VoidCallback that is passed in from the parent widget. It is used
  /// to pop the current widget off the stack.
  ///
  /// Returns:
  ///   A Future<void>
  Future<void> deleteUser(VoidCallback pop) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete User'),
            content: const Text('Are you sure you want to delete this user?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    AuthClass().deleteUserByID(widget.userID);
                    pop.call();
                  },
                  child: const Text('Delete'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // Size size = Get.size;
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.yellow.shade100,
        // backgroundColor: Colors.black,
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection(FirebaseName.usersCollection)
                .doc(widget.userID)
                .snapshots(),
            builder: (context, docs) {
              if (docs.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (docs.hasData) {
                return SingleChildScrollView(
                  controller: _fabcontroller,
                  child: Stack(children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      child: Image.asset(
                        AppStyle.defaultCoverPath,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: size.height * 0.17),
                              padding: const EdgeInsets.all(3), // Border width
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  shape: BoxShape.circle),
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size:
                                      const Size.fromRadius(48), // Image radius
                                  child: Image.network(
                                      docs.data!['profilePicture'],
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Center(
                            child: Text(
                              docs.data!['displayName'],
                              style: AppStyle.displayName,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text.rich(TextSpan(
                                  text: 'Team: ',
                                  style: AppStyle.title,
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: docs.data!['team'],
                                      style: AppStyle.content,
                                    )
                                  ])),
                              const SizedBox(width: 25),
                              Text.rich(TextSpan(
                                  text: 'Role: ',
                                  style: AppStyle.title,
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: docs.data!['role'],
                                      style: AppStyle.content,
                                    )
                                  ])),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            color: Colors.black45,
                            height: 0.4,
                            thickness: 1,
                          ),
                          const SizedBox(height: 10),
                          Text.rich(TextSpan(
                              text: 'Email: ',
                              style: AppStyle.title,
                              children: <InlineSpan>[
                                TextSpan(
                                  text: docs.data!['email'],
                                  style: AppStyle.content,
                                )
                              ])),
                          const SizedBox(height: 10),
                          Text.rich(TextSpan(
                              text: 'Joined At: ',
                              style: AppStyle.title,
                              children: <InlineSpan>[
                                TextSpan(
                                  text: docs.data!['joinedAt'],
                                  style: AppStyle.content,
                                )
                              ])),
                          const SizedBox(height: 10),
                          Text.rich(TextSpan(
                              text: 'About: ',
                              style: AppStyle.title,
                              children: <InlineSpan>[
                                TextSpan(
                                  text: docs.data!['about'],
                                  style: AppStyle.content,
                                )
                              ])),
                        ],
                      ),
                    ),
                  ]),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
        floatingActionButton: Obx(
          () => AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isFabVisible.value ? 1 : 0,
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(FirebaseName.usersCollection)
                      .doc(widget.userID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }
                    if (snapshot.hasData) {
                      return FancyFab(
                        openWidget1: EditUser(
                          docs: snapshot.data!,
                        ),
                        tooltip1: 'Edit',
                        icon1: const Icon(Icons.edit),
                        onPressed2: () => deleteUser(() {
                          showSnackBar(context, 'User deleted successfully');
                          Get.back();
                          Get.back();
                        }),
                        tooltip2: 'Delete',
                        icon2: const Icon(Icons.delete),
                        onPressed1: () {},
                      );
                    }
                    return const SizedBox();
                  })),
        ),
      ),
    );
  }
}
