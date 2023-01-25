import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mely_admin/styles/app_styles.dart';

class EventDetail extends StatefulWidget {
  final QueryDocumentSnapshot docs;
  const EventDetail({super.key, required this.docs});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(children: [
            Container(
              height: size.height * 0.35,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.docs['eventPicture']),
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
                        widget.docs['eventTitle'],
                        style: AppStyle.displayName,
                        overflow: TextOverflow.fade,
                        // maxLines: 2,
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    widget.docs['isEnded']
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
                                text: widget.docs['startTime'],
                                style: AppStyle.content,
                              )
                            ])),
                        SizedBox(width: size.width * 0.2),
                        Text.rich(TextSpan(
                            text: 'End at: ',
                            style: AppStyle.title,
                            children: <InlineSpan>[
                              TextSpan(
                                text: widget.docs['endTime'],
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
                              text: widget.docs['creator'],
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
                              text: widget.docs['description'],
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
      ),
    );
  }
}
