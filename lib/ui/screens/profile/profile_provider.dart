import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../providers.dart';
import 'profile_model.dart';
import 'profile_view.dart';

class ProfileProvider extends AuthenticatedProvider<ProfileModel, ProfileView> {
  ProfileProvider({Key? key}) : super(key: key);

  @override
  init(BuildContext context, ProfileModel model) async {
    if (await super.init(context, model)) {
      await loadUserData();
      return true;
    }
    return false;
  }

  @override
  ProfileView build(BuildContext context) => ProfileView();

  loadUserData() async {
    UserModel? user = authService.userModel;
    if (user != null) {
      model.images.clear();
      model.images.addAll(user.photos);
      model.images.add(null);
    }
  }
}
