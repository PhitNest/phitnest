import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_widgets/progress_widgets.dart';

import '../../../apis/api.dart';
import '../screens.dart';
import 'profile_edit_model.dart';
import 'profile_edit_view.dart';

class ProfileEditProvider
    extends AuthenticatedProvider<ProfileEditModel, ProfileEditView> {
  ProfileEditProvider({Key? key}) : super(key: key);

  @override
  Future<bool> init(BuildContext context, ProfileEditModel model) async {
    if (!await super.init(context, model)) {
      return false;
    }
    model.firstNameController.text = model.currentUser.firstName;
    model.lastNameController.text = model.currentUser.lastName;
    model.bioController.text = model.currentUser.bio;
    model.birthdayController.date = model.currentUser.birthday;

    return true;
  }

  @override
  ProfileEditView build(BuildContext context, ProfileEditModel model) =>
      ProfileEditView(
          onSelectPhoto: (File? photo) => model.profilePicture = photo,
          profilePictureUrlOrFile:
              model.profilePicture ?? model.currentUser.profilePictureUrl,
          firstNameController: model.firstNameController,
          lastNameController: model.lastNameController,
          bioController: model.bioController,
          birthdayController: model.birthdayController,
          onClickSubmit: () => onClickSubmit(context, model),
          formKey: model.formKey);

  onClickSubmit(BuildContext context, ProfileEditModel model) =>
      showProgressUntil(
          context: context,
          message: 'Updating profile...',
          showUntil: () async {
            if (model.profilePicture != null) {
              await api<StorageApi>().uploadProfilePicture(
                  model.currentUser.userId, model.profilePicture!);
              model.currentUser.profilePictureUrl = await api<StorageApi>()
                  .getProfilePictureURL(model.currentUser.userId);
            }
            await api<SocialApi>()
                .updateUserModel(model.currentUser
                  ..firstName = model.firstNameController.text
                  ..lastName = model.lastNameController.text
                  ..bio = model.bioController.text
                  ..birthday = model.birthdayController.date)
                .then((error) {
              if (error != null) {
                showAlertDialog(context, 'Update failed', error);
              }
            });
          });

  @override
  ProfileEditModel createModel() => ProfileEditModel();
}
