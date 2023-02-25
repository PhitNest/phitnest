part of home_page;

abstract class _IChatPageBase extends StatelessWidget {
  final Widget child;

  const _IChatPageBase({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            15.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                151.horizontalSpace,
                Text(
                  'Chat',
                  style: theme.textTheme.headlineLarge,
                ),
                Spacer(),
                StyledIndicator(
                  offset: Size(2, 0),
                  child: TextButton(
                    onPressed: () {
                      final homeBloc = context.homeBloc;
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => FriendsPage(
                            homeBloc: homeBloc,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'FRIENDS',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  count:
                      Cache.friendship.friendsAndRequests?.requests.length ?? 0,
                ),
                12.horizontalSpace,
              ],
            ),
            child,
          ],
        ),
      );
}
