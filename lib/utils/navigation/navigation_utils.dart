import 'package:flutter/material.dart';

class NavigationUtils {
  static pushReplacement(BuildContext context, Widget destination) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => destination));
  }

  static push(BuildContext context, Widget destination) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => destination));
  }

  static pushAndRemoveUntil(
      BuildContext context, Widget destination, bool predict) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => destination),
        (Route<dynamic> route) => predict);
  }
}
