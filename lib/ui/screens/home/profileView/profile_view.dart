import 'package:flutter/material.dart';

import '../../../../models/models.dart';
import '../../../common/textStyles/text_styles.dart';
import '../../../common/widgets/widgets.dart';

class ProfileView extends StatelessWidget {
  final AuthenticatedUser user;

  const ProfileView({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(children: [
          ProfilePictureWithStatus.fromNetwork(
            user.profilePictureUrl,
            key: Key('profileView_profilePicture'),
            showStatus: false,
            online: true,
          ),
          Text(
            user.firstName,
            style: BodyTextStyle(size: TextSize.LARGE),
          ),
          Text(
            user.lastName,
            style: BodyTextStyle(size: TextSize.LARGE),
          ),
          Text(
            user.bio,
            style: BodyTextStyle(size: TextSize.LARGE),
          ),
          StyledButton(
              key: Key('profileEdit_button'),
              text: 'Edit Profile',
              onClick: () => Navigator.pushNamed(context, '/editProfile')),
        ]),
      );
}
