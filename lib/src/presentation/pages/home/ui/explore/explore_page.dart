part of home_page;

class _ExplorePage extends StatelessWidget {
  const _ExplorePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<_ExploreBloc, _IExploreState>(
        listener: (context, state) {
          if (state is _IExploreMatchedState) {
            if (Cache.friendship.friendsAndMessages == null ||
                Cache.friendship.friendsAndMessages?.indexWhere((element) =>
                        element.friendship.id == state.friendship.id) ==
                    -1) {
              context.chatBloc.add(
                _ChatReceivedMessageEvent(
                  FriendsAndMessagesResponse(
                    friendship: PopulatedFriendshipEntity(
                      id: state.friendship.id,
                      userCognitoIds: state.friendship.userCognitoIds,
                      createdAt: state.friendship.createdAt,
                      friend: Cache.user.userExploreResponse![
                          state.currentPageIndex %
                              Cache.user.userExploreResponse!.length],
                    ),
                    message: null,
                  ),
                ),
              );
            }
          }
        },
        builder: (context, state) {
          if (state is _IExploreMatchedState) {
            return _ExploreMatchedPage(
              fullName: Cache
                  .user
                  .userExploreResponse![state.currentPageIndex %
                      Cache.user.userExploreResponse!.length]
                  .fullName,
              onPressedSayHello: () {
                context.exploreBloc.add(const _ExploreResetEvent());
              },
              onPressedMeetMore: () =>
                  context.exploreBloc.add(const _ExploreResetEvent()),
            );
          } else if (state is _IExploreLoadedState) {
            if (Cache.user.userExploreResponse!.isEmpty) {
              return const _ExploreEmptyPage();
            } else {
              return _ExploreLoadedPage(
                currentPageIndex: state.currentPageIndex,
                users: Cache.user.userExploreResponse!,
                onChangePage: (page) => context.exploreBloc.add(
                  _ExploreSetPageEvent(page),
                ),
                countdown:
                    state is _IExploreHoldingState ? state.countdown : null,
              );
            }
          } else {
            return const _ExploreLoadingPage();
          }
        },
      );
}
