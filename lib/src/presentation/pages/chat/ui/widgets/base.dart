part of chat_page;

abstract class _IChatPageBase extends StatelessWidget {
  final Widget child;

  const _IChatPageBase({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: SafeArea(
          child: Column(
            children: [
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
                  Stack(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'FRIENDS',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 9.w,
                            vertical: 2.5.h,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(32.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '5',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              40.verticalSpace,
              child,
            ],
          ),
        ),
      );
}
