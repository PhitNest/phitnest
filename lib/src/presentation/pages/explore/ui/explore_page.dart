part of explore_page;

extension _Bloc on BuildContext {
  _ExploreBloc get bloc => read();
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _ExploreBloc(
        withAuth: context.withAuth,
        withAuthVoid: context.withAuthVoid,
      ),
      child: BlocConsumer<_ExploreBloc, _ExploreState>(
        listener: (context, state) async {},
        builder: (context, state) {
          return Container();
        },
      ),
    );
  }
}
