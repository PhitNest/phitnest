import 'dart:io';

import 'package:flutter/material.dart';

import '../screens.dart';
import 'profile_model.dart';
import 'profile_view.dart';

class ProfileProvider extends AuthenticatedProvider<ProfileModel, ProfileView> {
  ProfileProvider({Key? key}) : super(key: key);

  @override
  ProfileView build(BuildContext context, ProfileModel model) => ProfileView(
      onSelectPhoto: (File? photo) => model.profilePicture = photo,
      profilePictureUrlOrFile:
          model.profilePicture ?? model.currentUser.profilePictureUrl,
      firstName: model.currentUser.firstName,
      lastName: model.currentUser.lastName);

  @override
  ProfileModel createModel() => ProfileModel();
}
