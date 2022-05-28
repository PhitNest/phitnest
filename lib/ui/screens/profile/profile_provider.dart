import 'package:flutter/material.dart';

import '../providers.dart';
import 'profile_model.dart';
import 'profile_view.dart';

class ProfileProvider extends AuthenticatedProvider<ProfileModel, ProfileView> {
  ProfileProvider() : super(key: Key("provider_profile"));

  @override
  ProfileView build(BuildContext context, ProfileModel model) => ProfileView();
}
