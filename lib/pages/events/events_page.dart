import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mely_admin/styles/app_styles.dart';
import 'package:mely_admin/widgets/events/event_card.dart';
import 'package:mely_admin/widgets/events/event_detail.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  // @override
  // void initState() {
  //   super.initState();
  //   _createUser();
  // }

  // Future<void> _createUser() async {
  //   await FirebaseFirestore.instance.collection('Events').add(
  //     {
  //       'eventName': 'Ong Dev Show',
  //       'eventPicture':
  //           'https://firebasestorage.googleapis.com/v0/b/flutter-to-do-application.appspot.com/o/defaultAvatar.jpg?alt=media&token=e1f98d07-d5e9-481c-8873-8aac1b7ee4f0',
  //       'startTime': '01/02/2022',
  //       'endTime': '03/02/2022',
  //       'creator': 'Truong Thanh Huy',
  //       'about': 'held at Discord',
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Events',
          style: AppStyle.title.copyWith(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Events').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return ListView(
                    children: snapshot.data!.docs
                        .map((docs) => OpenContainer(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              transitionType:
                                  ContainerTransitionType.fadeThrough,
                              closedBuilder: (context, action) =>
                                  eventCard(docs, context),
                              openBuilder: (context, action) => EventDetail(
                                docs: docs,
                              ),
                            ))
                        .toList(),
                  );
                }
                return const Center(child: Text('No data'));
              },
            ),
          )
        ],
      ),
    );
  }
}
