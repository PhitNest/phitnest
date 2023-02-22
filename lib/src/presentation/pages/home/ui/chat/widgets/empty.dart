part of home_page;

class _EmptyChatPage extends _IChatPageBase {
  _EmptyChatPage({Key? key})
      : super(
          key: key,
          child: Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 42.w),
                child: Text(
                  'Opps! Seems like you haven\'t started any conversation yet.',
                  style: theme.textTheme.labelLarge,
                ),
              ),
            ),
          ),
        );
}
