import 'package:flutter/material.dart';

import '../../../../../models/models.dart';
import '../../../screens.dart';
import '../../models/home_model.dart';
import '../../views/home_view.dart';

class ProfileProvider extends ScreenProvider<ProfileModel, ProfileView> {
  final AuthenticatedUser user;

  const ProfileProvider({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  ProfileView build(BuildContext context, ProfileModel model) => ProfileView(
        firstName: user.firstName,
        lastName: user.lastName,
        bio: user.bio,
        profilePictureUrl: user.profilePictureUrl,
      );

  @override
  ProfileModel createModel() => ProfileModel();
}
