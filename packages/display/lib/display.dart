import 'package:flutter/material.dart';

bool isDarkMode = false;
Color errorColor = Colors.red;

initialize({required bool darkMode, required Color error}) {
  isDarkMode = darkMode;
  errorColor = error;
}
