part of home_page;

class _LoadingChatPage extends _IChatPageBase {
  _LoadingChatPage()
      : super(
          child: Column(
            children: [
              120.verticalSpace,
              CircularProgressIndicator(),
            ],
          ),
        );
}
