import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui/ui.dart';

import '../../entities/entities.dart';
import '../../widgets/widgets.dart';
import '../home/home.dart';

class FriendsPage extends StatelessWidget {
  final String userId;
  final List<FriendWithoutMessageWithProfilePicture> friends;
  final List<FriendRequestWithProfilePicture> receivedFriendRequests;

  const FriendsPage({
    super.key,
    required this.userId,
    required this.friends,
    required this.receivedFriendRequests,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              64.verticalSpace,
              Text(
                'Friend requests',
                style: theme.textTheme.bodyLarge,
              ),
              32.verticalSpace,
              ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: receivedFriendRequests.length,
                itemBuilder: (context, i) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receivedFriendRequests[i].sender.firstName,
                      style: theme.textTheme.bodyMedium,
                    ),
                    9.verticalSpace,
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => context.sendFriendRequestBloc.add(
                              ParallelPushEvent(AuthReq(
                                  UserExploreWithPicture(
                                      user: receivedFriendRequests[i].sender,
                                      profilePicture: receivedFriendRequests[i]
                                          .profilePicture),
                                  context.sessionLoader))),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                          ),
                          child: Text(
                            'ACCEPT',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        16.horizontalSpace,
                        StyledOutlineButton(
                          hPadding: 17.w,
                          vPadding: 9.h,
                          onPress: () => context.sendFriendRequestBloc.add(
                              ParallelPushEvent(AuthReq(
                                  UserExploreWithPicture(
                                      user: receivedFriendRequests[i].sender,
                                      profilePicture: receivedFriendRequests[i]
                                          .profilePicture),
                                  context.sessionLoader))),
                          text: 'IGNORE',
                        )
                      ],
                    ),
                    18.verticalSpace,
                  ],
                ),
              ),
              Text(
                'Your Friends',
                style: theme.textTheme.bodyLarge,
              ),
              20.verticalSpace,
              ListView.builder(
                itemCount: friends.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, i) => Padding(
                  padding: EdgeInsets.all(8.h),
                  child: Text(
                    friends[i].other(userId).fullName,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
