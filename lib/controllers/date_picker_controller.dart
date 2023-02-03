import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

class DatePickerController extends GetxController {
  static DatePickerController get to => Get.find();
  String selected = DateTime.now()
      .toLocal()
      .toString()
      .split(' ')[0]
      .split('-')
      .reversed
      .join('/');

  /// This function is used to pick a date from a calendar and then convert it to a string
  ///
  /// Args:
  ///   context (BuildContext): The context of the widget that calls the function.
  void pickDate(BuildContext context) {
    DateTime now = DateTime.now();
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(now.year, now.month, now.day),
        maxTime: DateTime(2050, 12, 31), onChanged: (date) {
      selected = dateToString(date);
    }, onConfirm: (date) {
      selected = dateToString(date);
    }, currentTime: DateTime.now(), locale: LocaleType.en);
    update();
  }

  /// It takes a date, converts it to a string, splits the string into an array of strings, takes the
  /// first element of the array, splits that string into an array of strings, reverses the array, and
  /// joins the array into a string
  ///
  /// Args:
  ///   date (DateTime): The date to be formatted.
  ///
  /// Returns:
  ///   A string.
  String dateToString(DateTime date) {
    return date
        .toLocal()
        .toString()
        .split(' ')[0]
        .split('-')
        .reversed
        .join('/');
  }
}
