part of chat_page;

class _LoadingChatPage extends _IChatPageBase {
  _LoadingChatPage()
      : super(
          child: CircularProgressIndicator(),
        );
}
