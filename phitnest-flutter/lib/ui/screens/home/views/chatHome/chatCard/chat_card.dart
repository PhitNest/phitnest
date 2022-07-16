import 'package:flutter/material.dart';
import 'package:progress_widgets/progress_widgets.dart';

import '../../../../../common/textStyles/text_styles.dart';
import '../../../../../common/widgets/widgets.dart';

class ChatCard extends StatelessWidget {
  final String message;
  final bool read;
  final String pictureUrl;
  final Function() onTap;
  final Function(DismissDirection direction) onDismissConfirm;
  final bool? online;
  final String name;

  const ChatCard(
      {Key? key,
      required this.message,
      required this.read,
      required this.pictureUrl,
      required this.onTap,
      required this.onDismissConfirm,
      required this.online,
      required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Dismissible(
          confirmDismiss: (_) => showConfirmWidget(context, 'Confirm Delete?',
              'You will not be able to restore this conversation.'),
          onDismissed: onDismissConfirm,
          direction: DismissDirection.startToEnd,
          key: UniqueKey(),
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
                  ProfilePictureWithStatus.fromNetwork(
                    pictureUrl,
                    key: Key("profilePicture_$name"),
                    showStatus: online != null,
                    online: online ?? false,
                    scale: 0.4,
                  ),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text(
                                  name,
                                  style:
                                      HeadingTextStyle(size: TextSize.MEDIUM),
                                ),
                                Expanded(child: Container()),
                                Visibility(
                                    visible: !read,
                                    child: CircleAvatar(
                                      radius: 4,
                                      backgroundColor: Colors.blue,
                                    ))
                              ]),
                              Text(
                                message,
                                style: BodyTextStyle(size: TextSize.MEDIUM),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          )))
                ],
              ))));
}
