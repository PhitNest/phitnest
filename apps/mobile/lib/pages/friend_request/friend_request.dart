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

  Widget _ui(
    BuildContext context,
    FriendRequestPageState pageState,
    Set<String> loadingIds,
  ) =>
      Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            children: [
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: Container(
              //     margin: EdgeInsets.only(top: 32.h, bottom: 64.h),
              //     child: StyledOutlineButton(
              //       onPress: () => Navigator.pop(context, pageState),
              //       text: 'BACK',
              //     ),
              //   ),
              // ),
              32.verticalSpace,
              Text(
                'Friend requests',
                style: theme.textTheme.bodyLarge,
              ),
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
                      loadingIds.contains(
                        pageState.requests[i].sender.id,
                      )
                          ? const CircularProgressIndicator()
                          : Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () => context.sendFriendRequestBloc
                                      .add(ParallelPushEvent(AuthReq(
                                          UserExploreWithPicture(
                                            user: pageState.requests[i].sender,
                                            profilePicture: pageState
                                                .requests[i].profilePicture,
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
                                  onPress: () => context.deleteFriendshipBloc
                                      .add(ParallelPushEvent(AuthReq((
                                    pageState.requests[i],
                                    pageState.requests[i].profilePicture
                                  ), context.sessionLoader))),
                                  text: 'IGNORE',
                                ),
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
                    child: loadingIds
                            .contains(pageState.friends[i].other(userId).id)
                        ? const Center(child: CircularProgressIndicator())
                        : Row(
                            children: [
                              Text(
                                pageState.friends[i].other(userId).fullName,
                                style: theme.textTheme.bodyMedium,
                              ),
                              16.horizontalSpace,
                              StyledOutlineButton(
                                hPadding: 17.w,
                                vPadding: 9.h,
                                onPress: () => context.deleteFriendshipBloc.add(
                                    ParallelPushEvent(AuthReq((
                                  pageState.friends[i],
                                  pageState.friends[i].profilePicture
                                ), context.sessionLoader))),
                                text: 'REMOVE',
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

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
            create: (_) => DeleteFriendshipBloc(
              load: (friendship, session) =>
                  deleteFriendship(friendship.$1.other(userId).id, session),
            ),
          ),
          BlocProvider(
            create: (_) => FriendRequestPageBloc(
              userId: userId,
              initialFriends: initialFriends,
              initialReceivedRequests: initialReceivedRequests,
              initialExploreUsers: initialExploreUsers,
            ),
          ),
        ],
        child: DeleteFriendshipConsumer(
          listener: _handleDeleteFriendshipStateChanged,
          builder: (context, deleteFriendshipState) =>
              SendFriendRequestConsumer(
            listener: _handleSendFriendRequestStateChanged,
            builder: (context, sendFriendRequestState) {
              final loadingIds = {
                ...sendFriendRequestState.operations
                    .map((op) => op.req.data.user.id),
                ...deleteFriendshipState.operations
                    .map((op) => op.req.data.$1.other(userId).id),
              };
              return FriendRequestPageConsumer(
                listener: _handleFriendRequestPageStateChanged,
                builder: (context, pageState) => PopScope(
                  canPop: false,
                  onPopInvoked: (didPop) {
                    if (didPop) {
                      return;
                    }
                    Navigator.of(context).pop(pageState);
                  },
                  child: _ui(context, pageState, loadingIds),
                ),
              );
            },
          ),
        ),
      );
}
