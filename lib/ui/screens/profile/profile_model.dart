import 'package:flutter/material.dart';

import '../../../services/services.dart';
import '../../../models/models.dart';
import '../../../locator.dart';
import '../models.dart';

class ProfileModel extends BaseModel {
  UserModel? userModel;
  List images = [];
  List pages = [];
  List<Widget> gridPages = [];
  PageController controller = PageController();

  ProfileModel() : super(initiallyLoading: true);

  loadUserData() async {
    userModel = locator<AuthenticationService>().userModel;
    if (userModel != null) {
      images.clear();
      images.addAll(userModel!.photos);
      images.add(null);
    }
  }
}
