import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';
import '../../../widgets/styled_outline_button.dart';
import 'widgets/chat_conversation.dart';
import 'widgets/chat_tile.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              68.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chats',
                    style: AppTheme.instance.theme.textTheme.bodyLarge,
                  ),
                  StyledOutlineButton(
                    onPress: () {},
                    text: 'FRIENDS',
                  ),
                ],
              ),
              18.verticalSpace,
              ChatTile(
                name: 'Peter H.',
                message: 'Hey how are you?',
                onTap: () => Navigator.of(context).push(
                  CupertinoPageRoute<void>(
                    builder: (context) =>
                        const ChatConversation(name: 'Peter H.'),
                  ),
                ),
              ),
              ChatTile(
                name: 'Erin-Michelle J.',
                message: 'Yeah, how about you ?',
                onTap: () {},
              ),
            ],
          ),
        ),
      );
}
