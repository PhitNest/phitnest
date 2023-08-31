import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData get theme => ThemeData(
      scaffoldBackgroundColor: const Color(0xFF000000),
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF5E5CE6),
        onPrimary: Color(0xFF5E5CE6),
        secondary: Color(0xFFF4F9FF),
        onSecondary: Color(0xFFF4F9FF),
        error: Color(0xFFF4F9FF),
        onError: Color(0xFFF4F9FF),
        background: Color(0xFF000000),
        onBackground: Color(0xFF000000),
        surface: Color(0xFF000000),
        onSurface: Color(0xFF000000),
      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          height: 1.25,
          color: const Color(0xFFF8FEFF),
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          height: 1.25,
          color: const Color(0xFFF8FEFF),
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          height: 1.25,
          color: const Color(0xFFF8FEFF),
        ),
      ),
      appBarTheme: AppBarTheme(
        iconTheme: const IconThemeData(
          color: Color(0xFFF8FEFF),
        ),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          height: 1.25,
          color: const Color(0xFFF8FEFF),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 18.h,
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            const Color(0xFF5E5CE6),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.r),
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          textStyle: MaterialStateProperty.all(
            GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              height: 1.25,
              color: const Color(0xFFF4F9FF),
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
              decorationThickness: 1.5,
            ),
          ),
        ),
      ),
    );
