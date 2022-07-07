import 'dart:io';

import 'package:flutter/material.dart';

import '../../../apis/api.dart';
import '../../../models/models.dart';
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
    UserModel user = (await api<SocialApi>().getFullUserModel(
        (await api<AuthenticationApi>().getAuthenticatedUid())!))!;

    model.profilePictureDownloadUrl = user.profilePictureUrl;
    model.firstName = user.firstName;
    model.lastName = user.lastName;
    return true;
  }

  @override
  ProfileView build(BuildContext context, ProfileModel model) => ProfileView(
      onSelectPhoto: (File? photo) => model.profilePicture = photo,
      profilePictureUrlOrFile:
          model.profilePicture ?? model.profilePictureDownloadUrl,
      firstName: model.firstName,
      lastName: model.lastName);

  @override
  ProfileModel createModel() => ProfileModel();
}
