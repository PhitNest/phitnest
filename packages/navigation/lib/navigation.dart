import 'package:flutter/material.dart';

class Navigation {
  static pushReplacement(BuildContext context, Widget destination) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => destination));
  }

  static pushAndRemoveUntil(BuildContext context, Widget destination) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => destination), (route) => false);
  }

  static push(BuildContext context, Widget destination) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => destination));
  }
}
