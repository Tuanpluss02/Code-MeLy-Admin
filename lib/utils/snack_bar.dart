import 'package:flutter/material.dart';

/// It takes a context and a string, and shows a snackbar with the string as the text
///
/// Args:
///   context (BuildContext): The context of the widget that you want to show the snackbar on.
///   text (String): The text to show in the snackbar.
void showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
