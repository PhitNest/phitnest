part of home_page;

class _ExplorePage extends StatelessWidget {
  final _IExploreState state;

  const _ExplorePage({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) {
          final state = this.state;
          if (state is _IExploreMatchedState) {
            return _ExploreMatchedPage(
              fullName: state.friendship.friend.fullName,
              onPressedSayHello: () {
                context.exploreBloc.add(const _ExploreResetEvent());
                final homeBloc = context.homeBloc;
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => MessagePage(
                      friendship: state.friendship,
                      homeBloc: homeBloc,
                    ),
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
                pageController: context.exploreBloc.pageController,
                users: Cache.user.userExploreResponse!,
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
