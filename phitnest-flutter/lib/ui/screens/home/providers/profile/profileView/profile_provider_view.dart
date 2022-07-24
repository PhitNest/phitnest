import 'package:flutter/material.dart';
import 'package:phitnest/ui/screens/home/views/profileView/profile_view.dart';

import '../../../../../../models/models.dart';
import '../../../../screens.dart';
import '../../../models/home_model.dart';
import '../../../views/home_view.dart';

class ProfileProviderView extends ScreenProvider<ProfileModel, ProfileView> {
  final AuthenticatedUser user;

  const ProfileProviderView({Key? key, required this.user}) : super(key: key);
  // Change to ProfileView
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
