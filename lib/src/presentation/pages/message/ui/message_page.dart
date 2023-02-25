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
  Widget build(BuildContext context) => BlocProvider.value(
        value: homeBloc,
        child: BlocConsumer<HomeBloc, IHomeState>(
          listener: (context, state) {},
          builder: (context, homeState) => BlocWidget(
            create: (context) => _MessageBloc(
              authMethods: context.authMethods,
              friendship: friendship,
            ),
            builder: (context, state) {
              if (state is _LoadedState) {
                if (Cache.directMessage
                        .getDirectMessages(friendship.friend.id) !=
                    null) {
                  return _MessageLoaded(
                    message: 'message',
                    sentByMe: false,
                    name: 'name',
                  );
                } else {
                  return _EmptyMessagePage(
                    name: 'name',
                  );
                }
              } else if (state is _LoadingState) {
                return _LoadingPage(
                  name: 'name',
                );
              } else {
                return _LoadingPage(name: 'name');
              }
            },
          ),
        ),
      );
}
