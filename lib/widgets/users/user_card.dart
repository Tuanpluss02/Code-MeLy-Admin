import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mely_admin/styles/app_styles.dart';

Widget userCard(QueryDocumentSnapshot docs, BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(8),
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: (docs['role'] == 'Founder' ||
              docs['role'] == 'Co-Founder' ||
              docs['role'] == 'Leader')
          ? AppStyle.adminColor
          : AppStyle.memberColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Expanded(
        child: Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(docs['profilePicture']),
        ),
        const SizedBox(width: 10),
        Container(
          color: Colors.transparent,
          margin: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                docs['displayName'],
                style: AppStyle.displayName,
              ),
              const SizedBox(height: 10),
              Text.rich(TextSpan(
                  text: 'Team: ',
                  style: AppStyle.title,
                  children: <InlineSpan>[
                    TextSpan(
                      text: docs['team'],
                      style: AppStyle.content,
                    )
                  ])),
              const SizedBox(height: 10),
              Text.rich(TextSpan(
                  text: 'Role: ',
                  style: AppStyle.title,
                  children: <InlineSpan>[
                    TextSpan(
                      text: docs['role'],
                      style: AppStyle.content,
                    )
                  ])),
              // Text(
              //   "Role: ${docs['role']}",
              //   style: AppStyle.title,
              // ),
            ],
          ),
        )
      ],
    )),
  );
}
