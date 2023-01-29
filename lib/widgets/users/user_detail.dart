import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:mely_admin/styles/app_styles.dart';
import 'package:mely_admin/widgets/fab_custom.dart';

class UserView extends StatefulWidget {
  final QueryDocumentSnapshot docs;
  const UserView({super.key, required this.docs});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  late ScrollController _fabcontroller;
  late RxBool _isFabVisible;
  @override
  void initState() {
    super.initState();
    _fabcontroller = ScrollController();
    _isFabVisible = true.obs;
    _fabcontroller.addListener(() {
      if (_fabcontroller.position.userScrollDirection ==
          ScrollDirection.forward) {
        // _isFabVisible.value = !_isFabVisible.value ? true : false;
        if (_isFabVisible.value == false) _isFabVisible.value = true;
      } else if (_fabcontroller.position.userScrollDirection ==
          ScrollDirection.reverse) {
        // _isFabVisible.value = _isFabVisible.value ? false : true;
        if (_isFabVisible.value == true) _isFabVisible.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Size size = Get.size;
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.yellow.shade100,
        body: SingleChildScrollView(
          controller: _fabcontroller,
          child: Stack(children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              child: Image.asset(
                'assets/images/melycover.png',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: size.height * 0.17),
                        padding: const EdgeInsets.all(3), // Border width
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            shape: BoxShape.circle),
                        child: ClipOval(
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(48), // Image radius
                            child: Image.network(widget.docs['profilePicture'],
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.05),
                      Container(
                        // margin: EdgeInsets.only(top: size.height * 0.18),
                        padding: EdgeInsets.only(top: size.height * 0.25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.docs['displayName'],
                              style: AppStyle.displayName,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text.rich(TextSpan(
                                    text: 'Team: ',
                                    style: AppStyle.title,
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: widget.docs['team'],
                                        style: AppStyle.content,
                                      )
                                    ])),
                                const SizedBox(width: 25),
                                Text.rich(TextSpan(
                                    text: 'Role: ',
                                    style: AppStyle.title,
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: widget.docs['role'],
                                        style: AppStyle.content,
                                      )
                                    ])),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: Colors.black45,
                    height: 0.4,
                    thickness: 1,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text.rich(TextSpan(
                          text: 'Email: ',
                          style: AppStyle.title,
                          children: <InlineSpan>[
                            TextSpan(
                              text: widget.docs['email'],
                              style: AppStyle.content,
                            )
                          ])),
                      const SizedBox(width: 25),
                      Text.rich(TextSpan(
                          text: 'Joined At: ',
                          style: AppStyle.title,
                          children: <InlineSpan>[
                            TextSpan(
                              text: widget.docs['joinedAt'],
                              style: AppStyle.content,
                            )
                          ])),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text.rich(TextSpan(
                      text: 'About: ',
                      style: AppStyle.title,
                      children: <InlineSpan>[
                        TextSpan(
                          text: widget.docs['about'],
                          style: AppStyle.content,
                        )
                      ])),
                ],
              ),
            ),
          ]),
        ),
        floatingActionButton: Obx(
          () => AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isFabVisible.value ? 1 : 0,
              child: FancyFab(
                onPressed: () {},
                tooltip: 'Edit',
                icon: const Icon(Icons.arrow_back),
              )),
        ),
      ),
    );
  }
}
