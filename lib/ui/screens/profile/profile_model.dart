import 'package:flutter/material.dart';

import '../../../services/services.dart';
import '../../../models/models.dart';
import '../../../locator.dart';
import '../models.dart';

class ProfileModel extends BaseModel {
  final AuthenticationService _authService = locator<AuthenticationService>();

  List images = [];
  List pages = [];
  List<Widget> gridPages = [];
  PageController controller = PageController();

  loadUserData() async {
    UserModel? user = _authService.userModel;
    if (user != null) {
      images.clear();
      images.addAll(user.photos);
      images.add(null);
    }
  }
}
