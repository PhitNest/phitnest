import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phitnest/services/services.dart';

import '../providers.dart';
import 'profile_model.dart';
import 'profile_view.dart';

class ProfileProvider extends AuthenticatedProvider<ProfileModel, ProfileView> {
  ProfileProvider({Key? key}) : super(key: key);

  @override
  Future<bool> init(BuildContext context, ProfileModel model) async {
    if (!await super.init(context, model)) {
      return false;
    }
    model.profilePictureDownloadUrl = await storageService
        .getProfilePictureURL(authService.userModel!.userId);
    return true;
  }

  @override
  ProfileView build(BuildContext context, ProfileModel model) => ProfileView(
      onSelectPhoto: (File? photo) => model.profilePicture = photo,
      profilePicture: model.profilePicture != null
          ? Image.file(
              model.profilePicture!,
              fit: BoxFit.cover,
            )
          : model.profilePictureDownloadUrl != null
              ? Image.network(
                  model.profilePictureDownloadUrl!,
                  fit: BoxFit.cover,
                )
              : null,
      firstName: authService.userModel!.firstName,
      lastName: authService.userModel!.lastName);
}
