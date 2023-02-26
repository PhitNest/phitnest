part of message;

class _EmptyMessagePage extends _IBasePage {
  final String name;

  _EmptyMessagePage({
    Key? key,
    required this.name,
  }) : super(
          key: key,
          name: name,
          child: Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  'Say hello! :)',
                  style: theme.textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
}
