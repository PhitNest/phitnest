part of home_page;

class _ChatPage extends StatelessWidget {
  final _IChatState state;

  const _ChatPage({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) {
          if (state is _IChatLoadedState) {
            if (Cache.friendship.friendsAndMessages!.isEmpty) {
              return _EmptyChatPage();
            } else {
              return _AvailableChatPage(
                messages: Cache.friendship.friendsAndMessages!,
                onTap: (conversation) {
                  final homeBloc = context.homeBloc;
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => MessagePage(
                        homeBloc: homeBloc,
                        friendship: conversation.friendship,
                      ),
                    ),
                  );
                },
              );
            }
          } else {
            return _LoadingChatPage();
          }
        },
      );
}
