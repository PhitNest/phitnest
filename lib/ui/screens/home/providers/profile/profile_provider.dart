import 'package:flutter/material.dart';

import '../../../screens.dart';
import '../../models/home_model.dart';
import '../../views/home_view.dart';

class ProfileProvider extends ScreenProvider<ProfileModel, ProfileView> {
  final String firstName;
  final String lastName;
  final String bio;
  final String profilePictureUrl;

  const ProfileProvider({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.profilePictureUrl,
  }) : super(key: key);

  @override
  ProfileView build(BuildContext context, ProfileModel model) => ProfileView(
        firstName: firstName,
        lastName: lastName,
        bio: bio,
        profilePictureUrl: profilePictureUrl,
      );

  @override
  ProfileModel createModel() => ProfileModel();
}
