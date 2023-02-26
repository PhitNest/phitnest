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
                    loading: !(homeState is HomeSocketConnectedState) ||
                        state is _SendingState,
                    controller: context.bloc.messageController,
                    focusNode: context.bloc.messageFocus,
                    onSend: () => context.bloc.add(_SendEvent(
                        (homeState as HomeSocketConnectedState).connection)),
                    message: context.bloc.messages,
                    name: friendship.friend.fullName,
                  );
                } else {
                  return _EmptyMessagePage(
                    loading: !(homeState is HomeSocketConnectedState) ||
                        state is _SendingState,
                    name: friendship.friend.fullName,
                    controller: context.bloc.messageController,
                    focusNode: context.bloc.messageFocus,
                    onSend: () => context.bloc.add(_SendEvent(
                        (homeState as HomeSocketConnectedState).connection)),
                  );
                }
              } else if (state is _LoadingState) {
                return _LoadingPage(
                  loading: true,
                  name: friendship.friend.fullName,
                  controller: context.bloc.messageController,
                  focusNode: context.bloc.messageFocus,
                  onSend: () => context.bloc.add(_SendEvent(
                      (homeState as HomeSocketConnectedState).connection)),
                );
              } else {
                return _LoadingPage(
                  loading: !(homeState is HomeSocketConnectedState) ||
                      state is _SendingState,
                  name: friendship.friend.fullName,
                  controller: context.bloc.messageController,
                  focusNode: context.bloc.messageFocus,
                  onSend: () => context.bloc.add(_SendEvent(
                      (homeState as HomeSocketConnectedState).connection)),
                );
              }
            },
          ),
        ),
      );
}
