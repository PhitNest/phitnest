import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui/ui.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../../widgets/widgets.dart';
import '../pages.dart';

part 'bloc.dart';

class FriendsPage extends StatelessWidget {
  final String userId;
  final List<FriendWithoutMessageWithProfilePicture> initialFriends;
  final List<FriendRequestWithProfilePicture> initialReceivedRequests;
  final List<UserExploreWithPicture> initialExploreUsers;

  const FriendsPage({
    super.key,
    required this.userId,
    required this.initialFriends,
    required this.initialReceivedRequests,
    required this.initialExploreUsers,
  }) : super();

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => SendFriendRequestBloc(
                load: (user, session) =>
                    sendFriendRequest(user.user.id, session)),
          ),
          BlocProvider(
            create: (_) => FriendRequestPageBloc(
              initialFriends: initialFriends,
              initialReceivedRequests: initialReceivedRequests,
              initialExploreUsers: initialExploreUsers,
            ),
          ),
        ],
        child: SendFriendRequestConsumer(
          listener: _handleSendFriendRequestStateChanged,
          builder: (context, sendFriendRequestState) {
            final sendingIds = sendFriendRequestState.operations
                .map((op) => op.req.data.user.id)
                .toSet();
            return BlocConsumer<FriendRequestPageBloc, FriendRequestPageState>(
              listener: _handleFriendRequestPageStateChanged,
              builder: (context, pageState) => WillPopScope(
                onWillPop: () async {
                  Navigator.of(context).pop(pageState);
                  return true;
                },
                child: Scaffold(
                  body: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Column(
                      children: [
                        64.verticalSpace,
                        Text(
                          'Friend requests',
                          style: theme.textTheme.bodyLarge,
                        ),
                        32.verticalSpace,
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: pageState.requests.length,
                            itemBuilder: (context, i) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  pageState.requests[i].sender.fullName,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                9.verticalSpace,
                                sendingIds.contains(
                                  pageState.requests[i].sender.id,
                                )
                                    ? const CircularProgressIndicator()
                                    : Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () => context
                                                .sendFriendRequestBloc
                                                .add(ParallelPushEvent(AuthReq(
                                                    UserExploreWithPicture(
                                                      user: pageState
                                                          .requests[i].sender,
                                                      profilePicture: pageState
                                                          .requests[i]
                                                          .profilePicture,
                                                    ),
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
                                            onPress: () => context
                                                .sendFriendRequestBloc
                                                .add(ParallelPushEvent(AuthReq(
                                                    UserExploreWithPicture(
                                                      user: pageState
                                                          .requests[i].sender,
                                                      profilePicture: pageState
                                                          .requests[i]
                                                          .profilePicture,
                                                    ),
                                                    context.sessionLoader))),
                                            text: 'IGNORE',
                                          )
                                        ],
                                      ),
                                18.verticalSpace,
                              ],
                            ),
                          ),
                        ),
                        Text(
                          'Your Friends',
                          style: theme.textTheme.bodyLarge,
                        ),
                        20.verticalSpace,
                        Expanded(
                          child: ListView.builder(
                            itemCount: pageState.friends.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, i) => Padding(
                              padding: EdgeInsets.all(8.h),
                              child: Text(
                                pageState.friends[i].other(userId).fullName,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
}
