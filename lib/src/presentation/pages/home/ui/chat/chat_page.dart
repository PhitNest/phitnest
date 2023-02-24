part of home_page;

class _ChatPage extends StatelessWidget {
  const _ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocConsumer<_ChatBloc, _IChatState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is _IChatLoadedState) {
            if (Cache.friendship.friendsAndMessages!.isEmpty) {
              return _EmptyChatPage();
            } else {
              return _AvailableChatPage(
                messages: Cache.friendship.friendsAndMessages!,
              );
            }
          } else {
            return _LoadingChatPage();
          }
        },
      );
}
