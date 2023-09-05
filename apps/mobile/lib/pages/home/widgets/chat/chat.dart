import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui/ui.dart';

import '../../../../entities/friendship.dart';
import '../../../../widgets/widgets.dart';
import 'widgets/widgets.dart';

final class ChatPage extends StatelessWidget {
  final String userId;
  final List<FriendshipWithoutMessage> friends;
  final List<FriendRequest> sentFriendRequests;
  final List<FriendRequest> receivedFriendRequests;

  const ChatPage({
    super.key,
    required this.userId,
    required this.friends,
    required this.sentFriendRequests,
    required this.receivedFriendRequests,
  }) : super();

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
                    style: theme.textTheme.bodyLarge,
                  ),
                  StyledOutlineButton(
                    onPress: () {},
                    // onPress: () => Navigator.of(context).push(
                    //   CupertinoPageRoute<void>(
                    //     builder: (context) => const FriendRequestScreen(),
                    //   ),
                    // ),
                    text: 'FRIENDS',
                  ),
                ],
              ),
              18.verticalSpace,
              ...friends.map(
                (friend) => ChatTile(
                  name: '${friend.other(userId).firstName} '
                      '${friend.other(userId).lastName}',
                  message: 'Tap to chat',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      );
}
