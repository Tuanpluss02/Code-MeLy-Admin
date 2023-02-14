import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

class DatePickerController extends GetxController {
  static DatePickerController get to => Get.find();
  String date =
      '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
  String time = '${DateTime.now().hour}:${DateTime.now().minute}';

  /// This function is used to pick a date from a calendar and then convert it to a string
  ///
  /// Args:
  ///   context (BuildContext): The context of the widget that calls the function.
  void pickDate(BuildContext context) {
    // String time = '';
    // String date = '';
    DateTime now = DateTime.now();
    DatePicker.showTimePicker(context,
        theme: const DatePickerTheme(containerHeight: 210.0),
        showTitleActions: true,
        showSecondsColumn: false, onChanged: (val) {
      time = '${val.hour}:${val.minute}';
      update();
    }, onConfirm: (val) {
      time = '${val.hour}:${val.minute}';
      update();
    }, currentTime: DateTime.now(), locale: LocaleType.en);
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(now.year, now.month, now.day),
        maxTime: DateTime(2050, 12, 31), onChanged: (val) {
      date = '${val.day}/${val.month}/${val.year} ';
      update();
    }, onConfirm: (val) {
      date = '${val.day}/${val.month}/${val.year} ';
      update();
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }
}
