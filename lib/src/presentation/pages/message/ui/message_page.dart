part of message;

class MessagePage extends StatelessWidget {
  final HomeBloc homeBloc;
  final PopulatedFriendshipEntity friendship;

  const MessagePage({
    Key? key,
    required this.homeBloc,
    required this.friendship,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: homeBloc,
          ),
          BlocProvider(
            create: (context) => _MessageBloc(
              authMethods: context.authMethods,
              friendship: friendship,
            ),
          ),
        ],
        child: BlocConsumer<HomeBloc, IHomeState>(
          buildWhen: true.always,
          listenWhen: true.always,
          listener: (context, state) {},
          builder: (context, homeState) =>
              BlocConsumer<_MessageBloc, _IMessageState>(
            buildWhen: true.always,
            listenWhen: true.always,
            listener: (context, state) {},
            builder: (context, state) {
              if (state is _LoadedState) {
                if (Cache.directMessage
                        .getDirectMessages(friendship.friend.id) !=
                    null) {
                  return _MessageLoaded(
                    message: context.bloc.messages,
                    name: friendship.friend.fullName,
                  );
                } else {
                  return _EmptyMessagePage(name: friendship.friend.fullName);
                }
              } else if (state is _LoadingState) {
                return _LoadingPage(name: friendship.friend.fullName);
              } else {
                return _LoadingPage(name: friendship.friend.fullName);
              }
            },
          ),
        ),
      );
}
