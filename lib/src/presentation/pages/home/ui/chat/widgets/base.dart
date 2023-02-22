part of home_page;

abstract class _IChatPageBase extends StatelessWidget {
  final Widget child;

  const _IChatPageBase({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          55.verticalSpace,
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
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => FriendsPage(),
                    ),
                  ),
                  child: Text(
                    'FRIENDS',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                count: 5,
              ),
              12.horizontalSpace,
            ],
          ),
          child,
        ],
      );
}
