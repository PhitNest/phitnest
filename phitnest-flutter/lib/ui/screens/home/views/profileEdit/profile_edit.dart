import 'package:flutter/material.dart';

import '../../../../common/textStyles/text_styles.dart';
import '../../../../common/widgets/widgets.dart';
import '../../../screen_view.dart';

class ProfileEdit extends ScreenView {
  final String profilePictureUrl;
  final String firstName;
  final String lastName;
  final String bio;

  const ProfileEdit({
    Key? key,
    required this.profilePictureUrl,
    required this.firstName,
    required this.lastName,
    required this.bio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(children: [
          ProfilePictureWithStatus.fromNetwork(
            profilePictureUrl,
            key: Key('profileView_profilePicture'),
            showStatus: false,
            online: true,
          ),
          Text(
            firstName,
            style: BodyTextStyle(size: TextSize.LARGE),
          ),
          Text(
            lastName,
            style: BodyTextStyle(size: TextSize.LARGE),
          ),
          Text(
            bio,
            style: BodyTextStyle(size: TextSize.LARGE),
          ),
          StyledButton(
              key: Key('profileEdit_button'),
              text: 'Edit Profile',
              onClick: () => Navigator.pushNamed(context, '/editProfile')),
        ]),
      );
}
