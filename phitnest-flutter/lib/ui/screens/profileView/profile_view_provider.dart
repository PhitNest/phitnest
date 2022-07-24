import 'dart:io';

import 'package:flutter/material.dart';

import '../screens.dart';
import 'profile_view_model.dart';
import 'profile_view_view.dart';

class ProfileViewProvider
    extends AuthenticatedProvider<ProfileViewModel, ProfileViewView> {
  ProfileViewProvider({Key? key}) : super(key: key);

  @override
  Future<bool> init(BuildContext context, ProfileViewModel model) async {
    if (!await super.init(context, model)) {
      return false;
    }
    model.firstNameController.text = model.currentUser.firstName;
    model.lastNameController.text = model.currentUser.lastName;
    model.bioController.text = model.currentUser.bio;

    return true;
  }

  @override
  ProfileViewView build(BuildContext context, ProfileViewModel model) =>
      ProfileViewView(
          onSelectPhoto: (File? photo) => model.profilePicture = photo,
          profilePictureUrlOrFile:
              model.profilePicture ?? model.currentUser.profilePictureUrl,
          firstNameController: model.firstNameController,
          lastNameController: model.lastNameController,
          bioController: model.bioController,
          formKey: model.formKey);

  @override
  ProfileViewModel createModel() => ProfileViewModel();
}
