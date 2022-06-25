import 'package:flutter/material.dart';

import '../../../base_view.dart';
import '../../textStyles/text_styles.dart';
import '../widgets.dart';

class ChatCardView extends BaseView {
  final String fullName;
  final String profilePictureUrl;
  final String recentMessage;
  final bool online;

  const ChatCardView(
      {Key? key,
      required this.fullName,
      required this.profilePictureUrl,
      required this.online,
      required this.recentMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ProfilePictureChatStatus(
            key: Key("profilePicture_$fullName"),
            image: Image.network(profilePictureUrl, fit: BoxFit.cover),
            online: online,
            scale: 0.4,
          ),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
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
