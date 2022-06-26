import 'package:flutter/material.dart';

import '../../../base_view.dart';
import '../../textStyles/text_styles.dart';
import '../widgets.dart';

class ChatCardView extends BaseView {
  const ChatCardView({
    Key? key,
    required this.fullName,
    required this.profilePictureUrl,
    required this.online,
    required this.recentMessage,
    required this.onTap,
    required this.onDismiss,
    required this.confirmDismiss,
  }) : super(key: key);

  final Function() onTap;
  final Function(DismissDirection direction) onDismiss;
  final Future<bool> Function(DismissDirection direction) confirmDismiss;
  final String fullName;
  final bool online;
  final String profilePictureUrl;
  final String recentMessage;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Dismissible(
          confirmDismiss: confirmDismiss,
          onDismissed: onDismiss,
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
              ))));
}
