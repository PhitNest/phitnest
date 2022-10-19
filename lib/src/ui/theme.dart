import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Holds colors and text themes.
ThemeData theme = ThemeData(
  // Color scheme
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
      onSurface: Colors.black),
  // Text themes
  textTheme: TextTheme(
    // Headline
    headlineLarge: GoogleFonts.baskervville(
      fontSize: 32.sp,
      letterSpacing: -0.02,
      height: 1.1,
      color: Colors.black,
    ),
    headlineMedium: GoogleFonts.baskervville(
      fontSize: 24.sp,
      letterSpacing: -0.02,
      height: 1.1,
      color: Colors.black,
    ),
    // Label
    labelLarge: TextStyle(
      fontSize: 18.sp,
      height: 1.1,
      fontFamily: 'Metropolis',
    ),
    labelMedium: TextStyle(
      fontSize: 16.sp,
      height: 1.1,
      fontFamily: 'Metropolis',
    ),
    // Body
    bodyMedium: TextStyle(
      fontSize: 14.sp,
      fontFamily: 'Metropolis',
      letterSpacing: 0.02,
    ),
    bodySmall: TextStyle(
      fontSize: 12.sp,
      fontFamily: 'Metropolis',
      letterSpacing: 0.02,
    ),
  ),
);
