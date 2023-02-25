part of friends_page;

class FriendsPage extends StatelessWidget {
  final HomeBloc homeBloc;

  const FriendsPage({
    Key? key,
    required this.homeBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: homeBloc,
        child: BlocConsumer<HomeBloc, IHomeState>(
          listener: (context, state) {},
          builder: (context, homeState) => BlocWidget(
            create: (context) => _FriendsBloc(
              authMethods: context.authMethods,
            ),
            builder: (context, state) {
              if (state is _ILoadedState) {
                return const _LoadedPage();
              } else {
                return const _LoadingPage();
              }
            },
          ),
        ),
      );
}
