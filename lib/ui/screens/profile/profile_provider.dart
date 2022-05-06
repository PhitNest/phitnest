import 'package:flutter/material.dart';

import '../providers.dart';
import 'profile_model.dart';
import 'profile_view.dart';

class ProfileProvider extends AuthenticatedProvider<ProfileModel, ProfileView> {
  const ProfileProvider({Key? key}) : super(key: key);

  @override
  init(BuildContext context, ProfileModel model) async {
    if (await super.init(context, model)) {
      await model.loadUserData();
      return true;
    }
    return false;
  }

  @override
  ProfileView buildView(BuildContext context, ProfileModel model) =>
      ProfileView();
}
