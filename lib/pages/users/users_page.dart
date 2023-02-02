import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mely_admin/pages/users/add_user.dart';
import 'package:mely_admin/styles/app_styles.dart';
import 'package:mely_admin/widgets/users/user_card.dart';
import 'package:mely_admin/pages/users/user_detail.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Core Team',
          style: AppStyle.title.copyWith(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.filter_list,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddUser())),
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
                  FirebaseFirestore.instance.collection('Users').snapshots(),
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
                                  userCard(docs, context),
                              openBuilder: (context, action) => UserView(
                                userID: docs['userId'],
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
