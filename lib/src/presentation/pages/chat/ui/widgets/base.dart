part of chat_page;

abstract class _BasePage extends StatelessWidget {
  final Widget child;

  const _BasePage({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Chat',
                    style: theme.textTheme.headlineLarge,
                  ),
                  Positioned(
                    right: 0,
                    child: Stack(
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
                          child: Chip(
                            label: Text('2'),
                            backgroundColor: Colors.red,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            40.verticalSpace,
            child,
          ],
        ),
      );
}
