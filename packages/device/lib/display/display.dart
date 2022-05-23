import 'package:flutter/material.dart';

BorderRadius borderRadius = BorderRadius.circular(25.0);

bool isDarkMode = false;
Color primaryColor = Colors.blue;
Color accentColor = Colors.blueAccent;
Color errorColor = Colors.red;

initializeDisplay(BuildContext context) {
  ColorScheme colorScheme = Theme.of(context).colorScheme;
  isDarkMode = colorScheme.brightness == Brightness.dark;
  primaryColor = colorScheme.primary;
  accentColor = colorScheme.secondary;
  errorColor = colorScheme.error;
}
