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
                  'You don\'t have any friends yet. Go to the explore page and send some friend requests!',
                  style: theme.textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
}
