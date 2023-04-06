import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData get theme => ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Colors.black,
        onPrimary: Color.fromARGB(255, 117, 116, 116),
        secondary: Colors.white,
        onSecondary: Color.fromARGB(255, 118, 119, 118),
        tertiary: Color.fromARGB(255, 193, 28, 28),
        error: Colors.red,
        onError: Colors.red,
        background: Colors.white,
        onBackground: Colors.white,
        surface: Colors.black,
        onSurface: Colors.black,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.baskervville(
          fontSize: 32,
          letterSpacing: -0.02,
          height: 1.3,
          color: Colors.black,
        ),
        headlineMedium: GoogleFonts.baskervville(
          fontSize: 24,
          letterSpacing: -0.02,
          height: 1.3,
          color: Colors.black,
        ),
        headlineSmall: GoogleFonts.baskervville(
          fontSize: 18,
          letterSpacing: -0.02,
          height: 1.3,
          color: Colors.black,
        ),
        labelLarge: TextStyle(
          fontSize: 18,
          height: 1.3,
          fontFamily: 'Metropolis',
          color: Colors.black,
        ),
        labelMedium: TextStyle(
          fontSize: 16,
          height: 1.3,
          fontFamily: 'Metropolis',
          color: Colors.black,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontFamily: 'Metropolis',
          letterSpacing: 0.02,
          color: Colors.black,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontFamily: 'Metropolis',
          letterSpacing: 0.02,
          color: Colors.black,
        ),
      ),
    );
