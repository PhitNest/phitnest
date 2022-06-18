import 'package:flutter/material.dart';

import '../../../../models/models.dart';
import '../../../common/textStyles/text_styles.dart';
import '../../../common/widgets/widgets.dart';

class ChatCard extends StatelessWidget {
  final UserModel user;

  const ChatCard(
    this.user,
  ) : super();

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ProfilePictureChatStatus(
            key: Key("profilePicture_${user.userId}"),
            image: Image.network(user.settings.profilePictureURL,
                fit: BoxFit.cover),
            online: user.online,
            scale: 0.4,
          ),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: HeadingTextStyle(size: TextSize.MEDIUM),
                      ),
                      Text(
                        'Most recent message should be shown here',
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  )))
        ],
      ));
}
