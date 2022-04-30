import 'package:flutter/material.dart';

import '../../../../models/models.dart';

class UserDetailsModel extends ChangeNotifier {
  final UserModel viewingUser;

  List<String?> images = [];

  List pages = [];

  PageController controller = PageController(
    initialPage: 0,
  );

  PageController gridPageViewController = PageController(
    initialPage: 0,
  );

  List<Widget> gridPages = [];

  UserDetailsModel({required this.viewingUser});

  @override
  void dispose() {
    gridPageViewController.dispose();
    controller.dispose();
    super.dispose();
  }
}
