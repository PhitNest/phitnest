part of explore_page;

extension _Bloc on BuildContext {
  _ExploreBloc get bloc => read();
}

class ExplorePage extends StatelessWidget {
  final Stream<PressType> logoPressStream;
  final UserExploreResponse? initialData;
  final ValueChanged<UserExploreResponse> onLoaded;
  final String gymId;

  const ExplorePage({
    Key? key,
    required this.logoPressStream,
    required this.initialData,
    required this.onLoaded,
    required this.gymId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _ExploreBloc(
        withAuth: context.withAuth,
        withAuthVoid: context.withAuthVoid,
        logoPressStream: logoPressStream,
        initialData: initialData,
        gymId: gymId,
      ),
      child: BlocConsumer<_ExploreBloc, _ExploreState>(
        listener: (context, state) {
          if (state is _LoadedState) {
            onLoaded(state.userExploreResponse);
          }
        },
        builder: (context, state) {
          if (state is _LoadingErrorState) {
            return _ErrorPage(
              failure: state.failure,
              onPressedRetry: () => context.bloc.add(const _LoadEvent()),
            );
          } else if (state is _Loaded) {
            return _LoadedPage(
              users: state.userExploreResponse.users,
              onChangePage: (page) {},
              countdown: state is _HoldingState ? state.countdown : null,
            );
          } else {
            return const _LoadingPage();
          }
        },
      ),
    );
  }
}
