part of chat_page;

class _ChatPage extends StatelessWidget {
  final T Function<T>(T Function(String accessToken) f) withAuth;

  const _ChatPage({Key? key, required this.withAuth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _ChatBloc(withAuth: withAuth),
      child: BlocConsumer<_ChatBloc, _ChatState>(listener: (context, state) {
        if (state is _ErrorState) {
          ScaffoldMessenger.of(context).showMaterialBanner(
            StyledErrorBanner(
              err: state.failure.message,
              context: context,
            ),
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
