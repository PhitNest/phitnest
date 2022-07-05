import 'package:flutter/material.dart';
import 'package:progress_widgets/progress_widgets.dart';

import '../../../../models/models.dart';
import '../../../common/textStyles/text_styles.dart';
import '../../../common/widgets/widgets.dart';

class ChatCard extends StatelessWidget {
  final UserPublicInfo userInfo;
  final ChatMessage message;

  ChatCard({
    Key? key,
    required this.userInfo,
    required this.message,
  }) : super(key: key);

  operator <(ChatCard other) {
    return message <= other.message;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/chat', arguments: userInfo),
      child: Dismissible(
          confirmDismiss: (_) => showConfirmWidget(context, 'Confirm Delete?',
              'You will not be able to restore this conversation.'),
          onDismissed: (direction) {},
          direction: DismissDirection.startToEnd,
          key: Key(''),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 32.0,
            ),
          ),
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  ProfilePictureChatStatus.fromNetwork(
                    userInfo.profilePictureUrl,
                    key: Key("profilePicture_${userInfo.userId}"),
                    online: userInfo.online,
                    scale: 0.4,
                  ),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userInfo.fullName,
                                style: HeadingTextStyle(size: TextSize.MEDIUM),
                              ),
                              Text(
                                message.text,
                                style: BodyTextStyle(size: TextSize.MEDIUM),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          )))
                ],
              ))));
}
