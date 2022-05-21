import 'package:device/device.dart';
import 'package:flutter/material.dart';

class BackButtonAppBar extends AppBar {
  BackButtonAppBar()
      : super(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          iconTheme:
              IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        );
}
