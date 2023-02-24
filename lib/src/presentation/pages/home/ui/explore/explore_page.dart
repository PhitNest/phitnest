part of home_page;

class _ExplorePage extends StatelessWidget {
  const _ExplorePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<_ExploreBloc, _IExploreState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is _IExploreLoadedState) {
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
