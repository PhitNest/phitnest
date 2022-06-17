import 'package:flutter/material.dart';

import '../../../../models/models.dart';
import '../../../common/widgets/widgets.dart';

class ChatCard extends StatelessWidget {
  final UserModel user;

  const ChatCard(this.user) : super();

  @override
  Widget build(BuildContext context) => Row(
        children: [
          ProfilePictureChatStatus(
            key: Key("profilePicture_${user.userId}"),
            image: Image.network(user.settings.profilePictureURL,
                fit: BoxFit.cover),
            online: user.online,
            scale: 0.5,
          )
        ],
      );
}
