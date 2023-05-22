import 'package:flutter/material.dart';

class AppTheme {
  static Color gradientColorFrom = const Color(0xFFA3219D);
  static Color gradientColorTo = const Color(0xFF0B1253);

  static String firstFontName = "Ubuntu";
  static String secondFontName = "Lobster";

  static TextStyle loginTitleStyle =
      TextStyle(fontFamily: secondFontName, fontSize: 40, color: Colors.white);

  static TextStyle loginSubTitleTitleStyle = TextStyle(
      fontFamily: secondFontName, fontSize: 20, color: Colors.white70);

  static TextStyle loginHelpStyle =
      const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600);

  static BoxDecoration loginContainerBoxdecoration = BoxDecoration(
    gradient:
        LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft,
            // colors: [Color(0xff023b47), Color(0xff207b7d)]),
            colors: [gradientColorFrom, gradientColorTo]),
  );
}
