import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mely_admin/controllers/date_picker_controller.dart';
import 'package:mely_admin/controllers/image_picker.dart';
import 'package:mely_admin/controllers/loading_control.dart';
import 'package:mely_admin/models/event.dart';
import 'package:mely_admin/services/auth.dart';
import 'package:mely_admin/styles/app_styles.dart';
import 'package:mely_admin/utils/snack_bar.dart';

class AddEvent extends StatelessWidget {
  const AddEvent({super.key});

  @override
  Widget build(BuildContext context) {
    RxString showDate =
        '${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'
            .obs;
    final imageController = Get.find<ImageController>();
    final loadController = Get.find<LoadingControl>();
    final startTimePicker = Get.find<DatePickerController>();
    final formKey = GlobalKey<FormState>();
    Event event = Event(
      eventPicture: '',
      eventId: '',
      eventTitle: '',
      startTime: '',
      creator: '',
      description: '',
      isEnded: false,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          'Add Event',
          style: AppStyle.title.copyWith(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Column(
              children: [
                GetBuilder<ImageController>(builder: (_) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: imageController.image != null
                        ? Image.file(imageController.image!, fit: BoxFit.cover)
                        : Image.asset(AppStyle.defaultCoverPath,
                            fit: BoxFit.cover),
                  );
                }),
                const SizedBox(height: 10),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                imageController.getImage(context);
                              },
                              child: const Text('Pick Image'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                imageController.removeImage();
                              },
                              child: const Text('Default Image'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.black45),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            labelText: 'Event Title',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter event title';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            event.eventTitle = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                startTimePicker.pickDate(context);
                                event.startTime =
                                    '${startTimePicker.time} ${startTimePicker.date}';
                                showDate.value = event.startTime!;
                              },
                              icon: const Icon(Icons.calendar_today),
                              label: const Text('Start Time'),
                            ),
                            const SizedBox(width: 10),
                            Obx(() {
                              return Text(
                                showDate.value,
                                style: AppStyle.title.copyWith(fontSize: 15),
                              );
                            }),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          // initialValue: event.creator,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.black45),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            labelText: 'Creator',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter creator';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            event.creator = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                            maxLines: 5,
                            minLines: 3,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.black45),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              labelText: 'Description',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter description';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              event.description = value!;
                            }),
                        const SizedBox(height: 10),
                        Center(
                            child: Obx(() => !loadController.loading
                                ? SizedBox(
                                    // margin: const EdgeInsets.symmetric(horizontal: 10),
                                    width: Get.width,
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          formKey.currentState!.save();
                                          AuthClass().addEvent(
                                              event,
                                              imageController,
                                              loadController,
                                              context, () {
                                            showSnackBar(
                                                context, 'Event Added');
                                          });
                                        } else {
                                          showSnackBar(context,
                                              'Please fill all fields');
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        // padding: EdgeInsets.symmetric(horizontal: Get.width),
                                        backgroundColor:
                                            Colors.deepPurpleAccent,
                                        shape: const StadiumBorder(),
                                      ),
                                      child: const Text(
                                        "Add New Event",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                  )
                                : const CircularProgressIndicator())),
                      ],
                    )),
              ],
            )),
      ),
    );
  }
}
