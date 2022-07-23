import 'package:flutter/material.dart';
import 'package:progress_widgets/progress_widgets.dart';

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

    return true;
  }

  @override
  ProfileEditView build(BuildContext context, ProfileEditModel model) =>
      ProfileEditView(
          firstNameController: model.firstNameController,
          lastNameController: model.lastNameController,
          bioController: model.bioController,
          onClickSubmit: () => onClickSubmit(context, model),
          formKey: model.formKey);

  onClickSubmit(BuildContext context, ProfileEditModel model) =>
      showProgressUntil(
          context: context,
          message: 'Updating profile...',
          showUntil: () async {
            // Update profile
          });

  @override
  ProfileEditModel createModel() => ProfileEditModel();
}