import 'package:flutter/material.dart';

class UserDetailsModel extends ChangeNotifier {
  List<String?> images = [];

  List pages = [];

  PageController controller = PageController(
    initialPage: 0,
  );

  PageController gridPageViewController = PageController(
    initialPage: 0,
  );

  List<Widget> gridPages = [];

  UserDetailsModel();

  @override
  void dispose() {
    gridPageViewController.dispose();
    controller.dispose();
    super.dispose();
  }
}
