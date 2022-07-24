import 'package:flutter/material.dart';

import '../../../../../../models/models.dart';
import '../../../../screens.dart';
import '../../../models/home_model.dart';
import '../../../views/home_view.dart';

class ProfileProviderEdit extends ScreenProvider<ProfileModel, ProfileEdit> {
  final AuthenticatedUser user;

  const ProfileProviderEdit({Key? key, required this.user}) : super(key: key);

  @override
  ProfileEdit build(BuildContext context, ProfileModel model) => ProfileEdit(
        firstName: user.firstName,
        lastName: user.lastName,
        bio: user.bio,
        profilePictureUrl: user.profilePictureUrl,
      );

  @override
  ProfileModel createModel() => ProfileModel();
}
