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
              BlocProvider.of<_ChatBloc>(context).add(
                _ChatReceivedMessageEvent(
                  FriendsAndMessagesResponse(
                    friendship: state.friendship,
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
              fullName: state.friendship.friend.fullName,
              onPressedSayHello: () {
                context.exploreBloc.add(const _ExploreResetEvent());
                final homeBloc = context.homeBloc;
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) {
                      return MessagePage(
                        friendship: state.friendship,
                        homeBloc: homeBloc,
                      );
                    },
                  ),
                );
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
