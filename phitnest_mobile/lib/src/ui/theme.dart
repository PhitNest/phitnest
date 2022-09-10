import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var theme = ThemeData(
  // Color scheme
  colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Colors.black,
      onPrimary: Color.fromARGB(255, 117, 116, 116),
      secondary: Colors.white,
      onSecondary: Color.fromARGB(255, 118, 119, 118),
      error: Colors.red,
      onError: Colors.red,
      background: Colors.white,
      onBackground: Colors.white,
      surface: Colors.black,
      onSurface: Colors.black),
  // Text themes
  textTheme: TextTheme(
      // Headline
      headlineLarge: GoogleFonts.baskervville(
          fontSize: 32, letterSpacing: -0.02, color: Colors.black),
      // Label
      labelLarge: TextStyle(
        fontSize: 18,
        height: 1.56,
        fontFamily: 'Metropolis',
      ),
      // Body
      bodySmall: TextStyle(
        fontSize: 12,
        fontFamily: 'Metropolis',
      )),
);
