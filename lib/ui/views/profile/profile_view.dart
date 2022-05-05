import 'package:flutter/material.dart';

import '../redirected/redirected.dart';
import 'model/profile_model.dart';

class ProfileView extends AuthenticatedView<ProfileModel> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  init(BuildContext context, ProfileModel model) async {
    await super.init(context, model);

    if (!await shouldRedirect) {
      await model.loadUserData();
      model.loading = false;
    }
  }

  @override
  Widget build(BuildContext context, ProfileModel model) {
    return Scaffold();
  }
}
