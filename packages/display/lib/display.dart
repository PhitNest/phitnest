import 'package:flutter/material.dart';

BorderRadius borderRadius = BorderRadius.circular(25.0);

bool isDarkMode = false;
Color primaryColor = Colors.blue;
Color accentColor = Colors.blueAccent;
Color errorColor = Colors.red;

initialize(
    {required bool darkMode,
    required Color primary,
    required Color accent,
    required Color error}) {
  isDarkMode = darkMode;
  primaryColor = primary;
  accentColor = accent;
  errorColor = error;
}
