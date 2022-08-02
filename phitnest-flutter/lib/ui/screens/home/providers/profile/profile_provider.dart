import 'package:flutter/material.dart';

import '../../../screens.dart';
import '../../models/home_model.dart';
import '../../views/home_view.dart';

class ProfileProvider extends ScreenProvider<ProfileModel, ProfileView> {
  const ProfileProvider({
    Key? key,
  }) : super(key: key);

  @override
  ProfileView build(BuildContext context, ProfileModel model) => ProfileView(
        firstName: '',
        lastName: '',
        bio: '',
        onClickEditButton: () => Navigator.pushNamed(context, '/editProfile'),
      );

  @override
  ProfileModel createModel() => ProfileModel();
}
