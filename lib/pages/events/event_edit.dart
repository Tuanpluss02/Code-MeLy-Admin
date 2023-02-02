import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mely_admin/styles/app_styles.dart';

class EditEvent extends StatelessWidget {
  final DocumentSnapshot docs;
  const EditEvent({super.key, required this.docs});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
      ),
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            height: size.height * 0.35,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(docs['eventPicture']),
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
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              color: AppStyle.eventDetailColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  SizedBox(
                    width: size.width * 0.8,
                    child: Text(
                      docs['eventTitle'],
                      style: AppStyle.displayName,
                      overflow: TextOverflow.fade,
                      // maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  docs['isEnded']
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
                              text: docs['startTime'],
                              style: AppStyle.content,
                            )
                          ])),
                      SizedBox(width: size.width * 0.2),
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
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                        text: 'Creator: ',
                        style: AppStyle.title,
                        children: <InlineSpan>[
                          TextSpan(
                            text: docs['creator'],
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
                            text: docs['description'],
                            style: AppStyle.content,
                          )
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
