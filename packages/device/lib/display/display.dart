import 'package:flutter/material.dart';

BorderRadius borderRadius = BorderRadius.circular(14.0);

bool isDarkMode = false;
Color primaryColor = Colors.blue;
Color colorButton = primaryColor;
Color accentColor = Colors.blueAccent;
Color errorColor = Colors.red;

initialize({
  required bool darkMode,
  required Color primary,
  required Color accent,
  required Color error,
  Color? buttonColor,
}) {
  isDarkMode = darkMode;
  primaryColor = primary;
  colorButton = buttonColor ?? primaryColor;
  accentColor = accent;
  errorColor = error;
}
