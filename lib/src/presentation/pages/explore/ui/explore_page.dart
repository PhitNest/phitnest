part of explore_page;

class ExplorePage extends StatelessWidget {
  final Stream<PressType> logoPressStream;
  final ValueChanged<bool> onSetDarkMode;

  const ExplorePage({
    Key? key,
    required this.logoPressStream,
    required this.onSetDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocWidget<_ExploreBloc, _IExploreState>(
        create: (context) => _ExploreBloc(
          withAuth: context.withAuth,
          withAuthVoid: context.withAuthVoid,
          logoPressStream: logoPressStream,
        ),
        builder: (context, state) {
          if (state is _Loaded) {
            if (state.userExploreResponse.isEmpty) {
              context.setFreezeAnimation(true);
              return const _EmptyNestPage();
            } else {
              context.setFreezeAnimation(state is _HoldingState);
              return _LoadedPage(
                users: state.userExploreResponse,
                onChangePage: (page) {},
                countdown: state is _HoldingState ? state.countdown : null,
              );
            }
          } else {
            return const _LoadingPage();
          }
        },
      );
}
