import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:mely_admin/pages/events/event_edit.dart';
import 'package:mely_admin/services/auth.dart';
import 'package:mely_admin/styles/app_styles.dart';
import 'package:mely_admin/utils/snack_bar.dart';
import 'package:mely_admin/widgets/fab_custom.dart';

class EventDetail extends StatefulWidget {
  final QueryDocumentSnapshot docs;
  const EventDetail({super.key, required this.docs});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  late ScrollController _fabcontroller;
  late RxBool _fabVisible;

  @override
  void initState() {
    super.initState();
    _fabcontroller = ScrollController();
    _fabVisible = true.obs;
    _fabcontroller.addListener(() {
      if (_fabcontroller.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_fabVisible.value == false) _fabVisible.value = true;
      } else if (_fabcontroller.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_fabVisible.value == true) _fabVisible.value = false;
      }
    });
  }

  Future<void> deleteEvent(VoidCallback naviPop) async {
    showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Delete Event'),
            content: const Text('Are you sure you want to delete this event?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    AuthClass().deleteEventByID(widget.docs.id);
                    naviPop.call();
                  },
                  child: const Text('Delete'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Events')
                .doc(widget.docs.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  controller: _fabcontroller,
                  child: Stack(children: [
                    Container(
                      height: size.height * 0.35,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data!['eventPicture']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: size.height * 0.3),
                      padding: EdgeInsets.only(top: size.height * 0.03),
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        color: AppStyle.eventDetailColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            SizedBox(
                              width: size.width * 0.8,
                              child: AutoSizeText(
                                snapshot.data!['eventTitle'],
                                style: AppStyle.displayName,
                                overflow: TextOverflow.fade,
                                // maxLines: 2,
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 10),
                            snapshot.data!['isEnded']
                                ? const Text('This event has ended')
                                : const Text('This event will start after: '),
                            const SizedBox(height: 10),
                            const Divider(),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text.rich(TextSpan(
                                    text: 'Start at: ',
                                    style: AppStyle.title,
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: snapshot.data!['startTime'],
                                        style: AppStyle.content,
                                      )
                                    ])),
                                // SizedBox(width: size.width * 0.2),
                                // Text.rich(TextSpan(
                                //     text: 'End at: ',
                                //     style: AppStyle.title,
                                //     children: <InlineSpan>[
                                //       TextSpan(
                                //         text: snapshot.data!['endTime'],
                                //         style: AppStyle.content,
                                //       )
                                //     ])),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text.rich(
                              TextSpan(
                                  text: 'Creator: ',
                                  style: AppStyle.title,
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: snapshot.data!['creator'],
                                      style: AppStyle.content,
                                    )
                                  ]),
                            ),
                            const SizedBox(height: 10),
                            Text.rich(
                              TextSpan(
                                  text: 'Description: ',
                                  style: AppStyle.title,
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: snapshot.data!['description'],
                                      style: AppStyle.content,
                                    )
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                );
              }
              return const SizedBox();
            }),
        floatingActionButton: Obx(
          () => AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _fabVisible.value ? 1 : 0,
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Events')
                      .doc(widget.docs.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }
                    if (snapshot.hasData) {
                      return FancyFab(
                        onPressed1: () {},
                        openWidget1: EditEvent(
                          docs: snapshot.data!,
                        ),
                        tooltip1: 'Edit',
                        icon1: const Icon(Icons.edit),
                        onPressed2: () => deleteEvent(() {
                          showSnackBar(context, 'Event deleted successfully');
                          Get.back();
                          Get.back();
                        }),
                        tooltip2: 'Delete',
                        icon2: const Icon(Icons.delete),
                      );
                    }
                    return const SizedBox();
                  })),
        ),
      ),
    );
  }
}
