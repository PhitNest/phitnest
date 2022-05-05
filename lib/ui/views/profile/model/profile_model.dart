import 'package:flutter/material.dart';

import '../../../../services/authentication_service.dart';
import '../../../../models/user_model.dart';
import '../../../../locator.dart';
import '../../base_model.dart';

class ProfileModel extends BaseModel {
  UserModel? userModel;
  List<String?> images = [];
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
