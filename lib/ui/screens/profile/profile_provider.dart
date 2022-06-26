import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phitnest/services/services.dart';

import '../screens.dart';
import 'profile_model.dart';
import 'profile_view.dart';

class ProfileProvider extends AuthenticatedProvider<ProfileModel, ProfileView> {
  ProfileProvider({Key? key}) : super(key: key);

  @override
  Future<bool> init(BuildContext context, ProfileModel model) async {
    if (!await super.init(context, model)) {
      return false;
    }
    model.profilePictureDownloadUrl = authService.userModel!.profilePictureUrl;
    return true;
  }

  @override
  ProfileView build(BuildContext context, ProfileModel model) => ProfileView(
      onSelectPhoto: (File? photo) => model.profilePicture = photo,
      profilePictureUrlOrFile:
          model.profilePicture ?? model.profilePictureDownloadUrl,
      firstName: authService.userModel!.firstName,
      lastName: authService.userModel!.lastName);

  @override
  ProfileModel createModel() => ProfileModel();
}
