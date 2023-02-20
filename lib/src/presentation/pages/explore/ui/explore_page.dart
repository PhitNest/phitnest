part of explore_page;

extension _Bloc on BuildContext {
  _ExploreBloc get bloc => read();
}

class ExplorePage extends StatelessWidget {
  final Stream<PressType> logoPressStream;
  final ValueChanged<bool> onSetDarkMode;

  const ExplorePage({
    Key? key,
    required this.logoPressStream,
    required this.onSetDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _ExploreBloc(
        withAuth: context.withAuth,
        withAuthVoid: context.withAuthVoid,
        logoPressStream: logoPressStream,
      ),
      child: BlocConsumer<_ExploreBloc, _IExploreState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is _LoadingErrorState) {
            return _ErrorPage(
              failure: state.failure,
              onPressedRetry: () => context.bloc.add(const _LoadEvent()),
            );
          } else if (state is _Loaded) {
            if (state.userExploreResponse.users.isEmpty) {
              return const _EmptyNestPage();
            } else {
              return _LoadedPage(
                users: state.userExploreResponse.users,
                onChangePage: (page) {},
                countdown: state is _HoldingState ? state.countdown : null,
              );
            }
          } else {
            return const _LoadingPage();
          }
        },
      ),
    );
  }
}
