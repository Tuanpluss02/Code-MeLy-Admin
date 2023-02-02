import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  static Color mainColor = const Color.fromARGB(255, 4, 15, 97);
  static Color secondColor = const Color.fromARGB(255, 25, 109, 236);
  static Color bgColor = const Color(0xffe2e2ff);

  static List<Color> appColors = [
    Colors.white,
    Colors.red.shade100,
    Colors.pink.shade100,
    Colors.yellow.shade100,
    Colors.green.shade100,
    Colors.orange.shade100,
    Colors.blueGrey.shade100,
    Colors.blue.shade100,
  ];

  static Color memberColor = Colors.blue.shade100;
  static Color adminColor = Colors.orange.shade100;

  static Color endedEventColor = const Color.fromARGB(255, 247, 121, 121);
  static Color ongoingEventColor = const Color.fromARGB(255, 132, 244, 136);

  static Color eventDetailColor = Colors.yellow.shade100;

  static TextStyle displayName = GoogleFonts.roboto(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: mainColor,
  );
  static TextStyle content = GoogleFonts.livvic(
    fontSize: 16,
    color: mainColor,
    fontStyle: FontStyle.italic,
  );
  static TextStyle title = GoogleFonts.roboto(
    fontSize: 16,
    color: mainColor,
  );

  static String defaultCoverPath = 'assets/images/melycover.png';
  static String defaultAvatarPath = AppStyle.defaultAvatarPath;
}
