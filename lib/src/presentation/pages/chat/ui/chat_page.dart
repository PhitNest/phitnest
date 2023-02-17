part of chat_page;

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _ChatBloc(
        withAuth: context.withAuth,
        withAuthVoid: context.withAuthVoid,
      ),
      child: BlocConsumer<_ChatBloc, _IChatState>(listener: (context, state) {
        if (state is _ErrorState) {
          StyledErrorBanner.show(
            context,
            state.failure,
            state.dismiss,
          );
        }
      }, builder: (context, state) {
        if (state is _InitialState) {
          return _LoadingChatPage();
        } else if (state is _MessagesLoadedState) {
          if (state.messages.isEmpty) {
            return _EmptyChatPage();
          } else {
            return _AvailableChatPage(messages: state.messages);
          }
        } else {
          throw Exception('This is invalid state $state');
        }
      }),
    );
  }
}
