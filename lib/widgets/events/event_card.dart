import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mely_admin/styles/app_styles.dart';

Widget eventCard(QueryDocumentSnapshot docs, BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(8),
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: docs['isEnded'] == true
          ? AppStyle.endedEventColor
          : AppStyle.ongoingEventColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(docs['eventPicture']),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            color: Colors.transparent,
            margin: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    docs['eventTitle'],
                    style: AppStyle.displayName,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
                const SizedBox(height: 10),
                Text.rich(TextSpan(
                    text: 'Start at: ',
                    style: AppStyle.title,
                    children: <InlineSpan>[
                      TextSpan(
                        text: docs['startTime'],
                        style: AppStyle.content,
                      )
                    ])),
                const SizedBox(height: 10),
                Text.rich(TextSpan(
                    text: 'End at: ',
                    style: AppStyle.title,
                    children: <InlineSpan>[
                      TextSpan(
                        text: docs['endTime'],
                        style: AppStyle.content,
                      )
                    ])),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
