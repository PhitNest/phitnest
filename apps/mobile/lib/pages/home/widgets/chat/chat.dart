import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui/ui.dart';

import '../../../../entities/entities.dart';
import '../../../../widgets/widgets.dart';
import '../../../pages.dart';
import 'widgets/widgets.dart';

final class ChatPage extends StatelessWidget {
  final GetUserSuccess userResponse;

  const ChatPage({
    super.key,
    required this.userResponse,
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
                    onPress: () async {
                      final userBloc = context.userBloc;
                      final friendRequestState =
                          await Navigator.of(context).push(
                        CupertinoPageRoute<FriendRequestPageState>(
                          builder: (context) => FriendsPage(
                            initialReceivedRequests:
                                userResponse.receivedFriendRequests,
                            initialFriends: userResponse.friendships,
                            userId: userResponse.user.id,
                            initialExploreUsers: userResponse.exploreUsers,
                          ),
                        ),
                      );
                      userBloc.add(LoaderSetEvent(AuthRes(HttpResponseOk(
                          userResponse.copyWith(
                            friendships: friendRequestState!.friends,
                            receivedFriendRequests: friendRequestState.requests,
                            exploreUsers: friendRequestState.exploreUsers,
                          ),
                          null))));
                    },
                    text: 'FRIENDS',
                  ),
                ],
              ),
              18.verticalSpace,
              ...userResponse.friendships.map(
                (friend) => ChatTile(
                  name: friend.other(userResponse.user.id).fullName,
                  message: 'Tap to chat',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      );
}
